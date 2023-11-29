// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/FunctionsClient.sol";
import {ConfirmedOwner} from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/libraries/FunctionsRequest.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TicketImageConsumer is FunctionsClient, ConfirmedOwner {
    using FunctionsRequest for FunctionsRequest.Request;

    uint256 public requestsCounter;

    string public source;
    bytes32 public donId;
    uint64 public subscriptionId;
    uint32 public gasLimit;

    mapping(bytes32 => TicketImage) public requests;

    struct TicketImage {
        uint256 index;
        string location;
        string keyword;
        string ipfsHash;
        bool isUsed;
    }

    event TicketImageRequestCreated(
        bytes32 indexed requestId,
        string location,
        string keyword
    );

    event TicketImageRequestFulfilled(
        bytes32 indexed requestId,
        string ipfsHash
    );

    event RequestFailed(bytes32 indexed requestId, bytes error);

    constructor(
        address _router,
        string memory _source,
        bytes32 _donId,
        uint64 _subscriptionId,
        uint32 _gasLimit
    ) FunctionsClient(_router) ConfirmedOwner(msg.sender) {
        source = _source;
        donId = _donId;
        subscriptionId = _subscriptionId;
        gasLimit = _gasLimit;
    }

    /**
     * @notice Send a simple request

     * @param encryptedSecretsUrls Encrypted URLs where to fetch user secrets
     * @param location Location of the event
     * @param kewyword Keyword of the ticket image
     */
    function requestTicketImage(
        bytes memory encryptedSecretsUrls,
        string memory location,
        string memory kewyword
    ) external onlyOwner returns (bytes32) {
        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(source);
        if (encryptedSecretsUrls.length > 0)
            req.addSecretsReference(encryptedSecretsUrls);

        requestsCounter = requestsCounter + 1;

        uint256 ticketIndex = requestsCounter;

        string[] memory args = new string[](3);
        args[0] = Strings.toString(ticketIndex);
        args[1] = location;
        args[2] = kewyword;

        bytes32 requestId = _sendRequest(
            req.encodeCBOR(),
            subscriptionId,
            gasLimit,
            donId
        );

        requests[requestId] = TicketImage({
            index: ticketIndex,
            location: location,
            keyword: kewyword,
            ipfsHash: "",
            isUsed: false
        });

        emit TicketImageRequestCreated(requestId, args[0], args[1]);

        return requestId;
    }

    /**
     * @notice Store latest result/error
     * @param requestId The request ID, returned by sendRequest()
     * @param response Aggregated response from the user code
     * @param err Aggregated error from the user code or from the execution pipeline
     * Either response or error parameter will be set, but never both
     */
    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        if (err.length > 0) {
            emit RequestFailed(requestId, err);
            // remove the request from the mapping
            delete requests[requestId];

            return;
        }

        _processResponse(requestId, response);
    }

    function _processResponse(
        bytes32 requestId,
        bytes memory response
    ) private {
        string memory ipfsHash = string(response);

        requests[requestId].ipfsHash = ipfsHash;

        emit TicketImageRequestFulfilled(requestId, ipfsHash);
    }
}
