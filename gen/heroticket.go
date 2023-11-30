// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package heroticket

import (
	"errors"
	"math/big"
	"strings"

	ethereum "github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/event"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = errors.New
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
	_ = abi.ConvertType
)

// HeroticketMetaData contains all meta data concerning the Heroticket contract.
var HeroticketMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"addresspayable\",\"name\":\"accountImpl\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"registryImpl\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"ticketImageConsumerImpl\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"inputs\":[],\"name\":\"InvalidAddress\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"InvalidPaymentAmount\",\"type\":\"error\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"}],\"name\":\"OwnableInvalidOwner\",\"type\":\"error\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"}],\"name\":\"OwnableUnauthorizedAccount\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"TBAAlreadyExists\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"TicketNotIssuedByHeroTicket\",\"type\":\"error\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"previousOwner\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"OwnershipTransferred\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"TBACreated\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"bytes32\",\"name\":\"requestId\",\"type\":\"bytes32\"},{\"indexed\":false,\"internalType\":\"string\",\"name\":\"location\",\"type\":\"string\"},{\"indexed\":false,\"internalType\":\"string\",\"name\":\"keyword\",\"type\":\"string\"}],\"name\":\"TicketImageRequestCreated\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_ticketAddress\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_owner\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"string\",\"name\":\"_ticketName\",\"type\":\"string\"},{\"indexed\":false,\"internalType\":\"string\",\"name\":\"_ticketSymbol\",\"type\":\"string\"},{\"indexed\":false,\"internalType\":\"string\",\"name\":\"_ticketUri\",\"type\":\"string\"},{\"indexed\":false,\"internalType\":\"address\",\"name\":\"_initialOwner\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"_ticketAmount\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"_ticketEthPrice\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"_ticketTokenPrice\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"_saleDuration\",\"type\":\"uint256\"}],\"name\":\"TicketIssued\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_ticketAddress\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_buyer\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"_ticketId\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"enumITicketExtended.TicketSaleType\",\"name\":\"_saleType\",\"type\":\"uint8\"}],\"name\":\"TicketSold\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_issuer\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"_ticketTokenPrice\",\"type\":\"uint256\"}],\"name\":\"TokenPaymentForIssueTicket\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"TokenReward\",\"type\":\"event\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"name\":\"_tickets\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_ticketAddress\",\"type\":\"address\"}],\"name\":\"buyTicketByEther\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"payable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_ticketAddress\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"_buyer\",\"type\":\"address\"}],\"name\":\"buyTicketByToken\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"string\",\"name\":\"tokenURI\",\"type\":\"string\"}],\"name\":\"createTBA\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"payable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"ticketAddress\",\"type\":\"address\"}],\"name\":\"hasTicket\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"ticketAddress\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"}],\"name\":\"isWhiteListed\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"ticketName\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"ticketSymbol\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"ticketUri\",\"type\":\"string\"},{\"internalType\":\"address\",\"name\":\"issuer\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"ticketAmount\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"ticketEthPrice\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"ticketTokenPrice\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"saleDuration\",\"type\":\"uint256\"}],\"name\":\"issueTicket\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"issuedTicket\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"name\":\"ownedTickets\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"renounceOwnership\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes\",\"name\":\"encryptedSecretsUrls\",\"type\":\"bytes\"},{\"internalType\":\"string\",\"name\":\"location\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"keyword\",\"type\":\"string\"}],\"name\":\"requestTicketImage\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"requestId\",\"type\":\"bytes32\"}],\"name\":\"requests\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"},{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"tbaAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"}],\"name\":\"ticketsByOwner\",\"outputs\":[{\"internalType\":\"address[]\",\"name\":\"\",\"type\":\"address[]\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"}],\"name\":\"tokenBalanceOf\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnership\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_ticketAddress\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"}],\"name\":\"updateWhiteList\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]",
}

// HeroticketABI is the input ABI used to generate the binding from.
// Deprecated: Use HeroticketMetaData.ABI instead.
var HeroticketABI = HeroticketMetaData.ABI

// Heroticket is an auto generated Go binding around an Ethereum contract.
type Heroticket struct {
	HeroticketCaller     // Read-only binding to the contract
	HeroticketTransactor // Write-only binding to the contract
	HeroticketFilterer   // Log filterer for contract events
}

// HeroticketCaller is an auto generated read-only Go binding around an Ethereum contract.
type HeroticketCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// HeroticketTransactor is an auto generated write-only Go binding around an Ethereum contract.
type HeroticketTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// HeroticketFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type HeroticketFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// HeroticketSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type HeroticketSession struct {
	Contract     *Heroticket       // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// HeroticketCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type HeroticketCallerSession struct {
	Contract *HeroticketCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts     // Call options to use throughout this session
}

// HeroticketTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type HeroticketTransactorSession struct {
	Contract     *HeroticketTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts     // Transaction auth options to use throughout this session
}

// HeroticketRaw is an auto generated low-level Go binding around an Ethereum contract.
type HeroticketRaw struct {
	Contract *Heroticket // Generic contract binding to access the raw methods on
}

// HeroticketCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type HeroticketCallerRaw struct {
	Contract *HeroticketCaller // Generic read-only contract binding to access the raw methods on
}

// HeroticketTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type HeroticketTransactorRaw struct {
	Contract *HeroticketTransactor // Generic write-only contract binding to access the raw methods on
}

// NewHeroticket creates a new instance of Heroticket, bound to a specific deployed contract.
func NewHeroticket(address common.Address, backend bind.ContractBackend) (*Heroticket, error) {
	contract, err := bindHeroticket(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &Heroticket{HeroticketCaller: HeroticketCaller{contract: contract}, HeroticketTransactor: HeroticketTransactor{contract: contract}, HeroticketFilterer: HeroticketFilterer{contract: contract}}, nil
}

// NewHeroticketCaller creates a new read-only instance of Heroticket, bound to a specific deployed contract.
func NewHeroticketCaller(address common.Address, caller bind.ContractCaller) (*HeroticketCaller, error) {
	contract, err := bindHeroticket(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &HeroticketCaller{contract: contract}, nil
}

// NewHeroticketTransactor creates a new write-only instance of Heroticket, bound to a specific deployed contract.
func NewHeroticketTransactor(address common.Address, transactor bind.ContractTransactor) (*HeroticketTransactor, error) {
	contract, err := bindHeroticket(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &HeroticketTransactor{contract: contract}, nil
}

// NewHeroticketFilterer creates a new log filterer instance of Heroticket, bound to a specific deployed contract.
func NewHeroticketFilterer(address common.Address, filterer bind.ContractFilterer) (*HeroticketFilterer, error) {
	contract, err := bindHeroticket(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &HeroticketFilterer{contract: contract}, nil
}

// bindHeroticket binds a generic wrapper to an already deployed contract.
func bindHeroticket(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := HeroticketMetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Heroticket *HeroticketRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Heroticket.Contract.HeroticketCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Heroticket *HeroticketRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Heroticket.Contract.HeroticketTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Heroticket *HeroticketRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Heroticket.Contract.HeroticketTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Heroticket *HeroticketCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Heroticket.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Heroticket *HeroticketTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Heroticket.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Heroticket *HeroticketTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Heroticket.Contract.contract.Transact(opts, method, params...)
}

// Tickets is a free data retrieval call binding the contract method 0x78a2db88.
//
// Solidity: function _tickets(uint256 ) view returns(address)
func (_Heroticket *HeroticketCaller) Tickets(opts *bind.CallOpts, arg0 *big.Int) (common.Address, error) {
	var out []interface{}
	err := _Heroticket.contract.Call(opts, &out, "_tickets", arg0)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Tickets is a free data retrieval call binding the contract method 0x78a2db88.
//
// Solidity: function _tickets(uint256 ) view returns(address)
func (_Heroticket *HeroticketSession) Tickets(arg0 *big.Int) (common.Address, error) {
	return _Heroticket.Contract.Tickets(&_Heroticket.CallOpts, arg0)
}

// Tickets is a free data retrieval call binding the contract method 0x78a2db88.
//
// Solidity: function _tickets(uint256 ) view returns(address)
func (_Heroticket *HeroticketCallerSession) Tickets(arg0 *big.Int) (common.Address, error) {
	return _Heroticket.Contract.Tickets(&_Heroticket.CallOpts, arg0)
}

// HasTicket is a free data retrieval call binding the contract method 0xfce4d315.
//
// Solidity: function hasTicket(address owner, address ticketAddress) view returns(bool)
func (_Heroticket *HeroticketCaller) HasTicket(opts *bind.CallOpts, owner common.Address, ticketAddress common.Address) (bool, error) {
	var out []interface{}
	err := _Heroticket.contract.Call(opts, &out, "hasTicket", owner, ticketAddress)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// HasTicket is a free data retrieval call binding the contract method 0xfce4d315.
//
// Solidity: function hasTicket(address owner, address ticketAddress) view returns(bool)
func (_Heroticket *HeroticketSession) HasTicket(owner common.Address, ticketAddress common.Address) (bool, error) {
	return _Heroticket.Contract.HasTicket(&_Heroticket.CallOpts, owner, ticketAddress)
}

// HasTicket is a free data retrieval call binding the contract method 0xfce4d315.
//
// Solidity: function hasTicket(address owner, address ticketAddress) view returns(bool)
func (_Heroticket *HeroticketCallerSession) HasTicket(owner common.Address, ticketAddress common.Address) (bool, error) {
	return _Heroticket.Contract.HasTicket(&_Heroticket.CallOpts, owner, ticketAddress)
}

// IsWhiteListed is a free data retrieval call binding the contract method 0xa10cda99.
//
// Solidity: function isWhiteListed(address ticketAddress, address to) view returns(bool)
func (_Heroticket *HeroticketCaller) IsWhiteListed(opts *bind.CallOpts, ticketAddress common.Address, to common.Address) (bool, error) {
	var out []interface{}
	err := _Heroticket.contract.Call(opts, &out, "isWhiteListed", ticketAddress, to)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsWhiteListed is a free data retrieval call binding the contract method 0xa10cda99.
//
// Solidity: function isWhiteListed(address ticketAddress, address to) view returns(bool)
func (_Heroticket *HeroticketSession) IsWhiteListed(ticketAddress common.Address, to common.Address) (bool, error) {
	return _Heroticket.Contract.IsWhiteListed(&_Heroticket.CallOpts, ticketAddress, to)
}

// IsWhiteListed is a free data retrieval call binding the contract method 0xa10cda99.
//
// Solidity: function isWhiteListed(address ticketAddress, address to) view returns(bool)
func (_Heroticket *HeroticketCallerSession) IsWhiteListed(ticketAddress common.Address, to common.Address) (bool, error) {
	return _Heroticket.Contract.IsWhiteListed(&_Heroticket.CallOpts, ticketAddress, to)
}

// IssuedTicket is a free data retrieval call binding the contract method 0x664f7d5f.
//
// Solidity: function issuedTicket(address ) view returns(bool)
func (_Heroticket *HeroticketCaller) IssuedTicket(opts *bind.CallOpts, arg0 common.Address) (bool, error) {
	var out []interface{}
	err := _Heroticket.contract.Call(opts, &out, "issuedTicket", arg0)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IssuedTicket is a free data retrieval call binding the contract method 0x664f7d5f.
//
// Solidity: function issuedTicket(address ) view returns(bool)
func (_Heroticket *HeroticketSession) IssuedTicket(arg0 common.Address) (bool, error) {
	return _Heroticket.Contract.IssuedTicket(&_Heroticket.CallOpts, arg0)
}

// IssuedTicket is a free data retrieval call binding the contract method 0x664f7d5f.
//
// Solidity: function issuedTicket(address ) view returns(bool)
func (_Heroticket *HeroticketCallerSession) IssuedTicket(arg0 common.Address) (bool, error) {
	return _Heroticket.Contract.IssuedTicket(&_Heroticket.CallOpts, arg0)
}

// OwnedTickets is a free data retrieval call binding the contract method 0x99eb3759.
//
// Solidity: function ownedTickets(address , uint256 ) view returns(address)
func (_Heroticket *HeroticketCaller) OwnedTickets(opts *bind.CallOpts, arg0 common.Address, arg1 *big.Int) (common.Address, error) {
	var out []interface{}
	err := _Heroticket.contract.Call(opts, &out, "ownedTickets", arg0, arg1)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// OwnedTickets is a free data retrieval call binding the contract method 0x99eb3759.
//
// Solidity: function ownedTickets(address , uint256 ) view returns(address)
func (_Heroticket *HeroticketSession) OwnedTickets(arg0 common.Address, arg1 *big.Int) (common.Address, error) {
	return _Heroticket.Contract.OwnedTickets(&_Heroticket.CallOpts, arg0, arg1)
}

// OwnedTickets is a free data retrieval call binding the contract method 0x99eb3759.
//
// Solidity: function ownedTickets(address , uint256 ) view returns(address)
func (_Heroticket *HeroticketCallerSession) OwnedTickets(arg0 common.Address, arg1 *big.Int) (common.Address, error) {
	return _Heroticket.Contract.OwnedTickets(&_Heroticket.CallOpts, arg0, arg1)
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() view returns(address)
func (_Heroticket *HeroticketCaller) Owner(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Heroticket.contract.Call(opts, &out, "owner")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() view returns(address)
func (_Heroticket *HeroticketSession) Owner() (common.Address, error) {
	return _Heroticket.Contract.Owner(&_Heroticket.CallOpts)
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() view returns(address)
func (_Heroticket *HeroticketCallerSession) Owner() (common.Address, error) {
	return _Heroticket.Contract.Owner(&_Heroticket.CallOpts)
}

// Requests is a free data retrieval call binding the contract method 0x9d866985.
//
// Solidity: function requests(bytes32 requestId) view returns(uint256, string, string, string, bool)
func (_Heroticket *HeroticketCaller) Requests(opts *bind.CallOpts, requestId [32]byte) (*big.Int, string, string, string, bool, error) {
	var out []interface{}
	err := _Heroticket.contract.Call(opts, &out, "requests", requestId)

	if err != nil {
		return *new(*big.Int), *new(string), *new(string), *new(string), *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)
	out1 := *abi.ConvertType(out[1], new(string)).(*string)
	out2 := *abi.ConvertType(out[2], new(string)).(*string)
	out3 := *abi.ConvertType(out[3], new(string)).(*string)
	out4 := *abi.ConvertType(out[4], new(bool)).(*bool)

	return out0, out1, out2, out3, out4, err

}

// Requests is a free data retrieval call binding the contract method 0x9d866985.
//
// Solidity: function requests(bytes32 requestId) view returns(uint256, string, string, string, bool)
func (_Heroticket *HeroticketSession) Requests(requestId [32]byte) (*big.Int, string, string, string, bool, error) {
	return _Heroticket.Contract.Requests(&_Heroticket.CallOpts, requestId)
}

// Requests is a free data retrieval call binding the contract method 0x9d866985.
//
// Solidity: function requests(bytes32 requestId) view returns(uint256, string, string, string, bool)
func (_Heroticket *HeroticketCallerSession) Requests(requestId [32]byte) (*big.Int, string, string, string, bool, error) {
	return _Heroticket.Contract.Requests(&_Heroticket.CallOpts, requestId)
}

// TbaAddress is a free data retrieval call binding the contract method 0x97cd6077.
//
// Solidity: function tbaAddress(address ) view returns(address)
func (_Heroticket *HeroticketCaller) TbaAddress(opts *bind.CallOpts, arg0 common.Address) (common.Address, error) {
	var out []interface{}
	err := _Heroticket.contract.Call(opts, &out, "tbaAddress", arg0)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// TbaAddress is a free data retrieval call binding the contract method 0x97cd6077.
//
// Solidity: function tbaAddress(address ) view returns(address)
func (_Heroticket *HeroticketSession) TbaAddress(arg0 common.Address) (common.Address, error) {
	return _Heroticket.Contract.TbaAddress(&_Heroticket.CallOpts, arg0)
}

// TbaAddress is a free data retrieval call binding the contract method 0x97cd6077.
//
// Solidity: function tbaAddress(address ) view returns(address)
func (_Heroticket *HeroticketCallerSession) TbaAddress(arg0 common.Address) (common.Address, error) {
	return _Heroticket.Contract.TbaAddress(&_Heroticket.CallOpts, arg0)
}

// TicketsByOwner is a free data retrieval call binding the contract method 0xbf295ea8.
//
// Solidity: function ticketsByOwner(address owner) view returns(address[])
func (_Heroticket *HeroticketCaller) TicketsByOwner(opts *bind.CallOpts, owner common.Address) ([]common.Address, error) {
	var out []interface{}
	err := _Heroticket.contract.Call(opts, &out, "ticketsByOwner", owner)

	if err != nil {
		return *new([]common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new([]common.Address)).(*[]common.Address)

	return out0, err

}

// TicketsByOwner is a free data retrieval call binding the contract method 0xbf295ea8.
//
// Solidity: function ticketsByOwner(address owner) view returns(address[])
func (_Heroticket *HeroticketSession) TicketsByOwner(owner common.Address) ([]common.Address, error) {
	return _Heroticket.Contract.TicketsByOwner(&_Heroticket.CallOpts, owner)
}

// TicketsByOwner is a free data retrieval call binding the contract method 0xbf295ea8.
//
// Solidity: function ticketsByOwner(address owner) view returns(address[])
func (_Heroticket *HeroticketCallerSession) TicketsByOwner(owner common.Address) ([]common.Address, error) {
	return _Heroticket.Contract.TicketsByOwner(&_Heroticket.CallOpts, owner)
}

// TokenBalanceOf is a free data retrieval call binding the contract method 0xe42c08f2.
//
// Solidity: function tokenBalanceOf(address owner) view returns(uint256)
func (_Heroticket *HeroticketCaller) TokenBalanceOf(opts *bind.CallOpts, owner common.Address) (*big.Int, error) {
	var out []interface{}
	err := _Heroticket.contract.Call(opts, &out, "tokenBalanceOf", owner)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// TokenBalanceOf is a free data retrieval call binding the contract method 0xe42c08f2.
//
// Solidity: function tokenBalanceOf(address owner) view returns(uint256)
func (_Heroticket *HeroticketSession) TokenBalanceOf(owner common.Address) (*big.Int, error) {
	return _Heroticket.Contract.TokenBalanceOf(&_Heroticket.CallOpts, owner)
}

// TokenBalanceOf is a free data retrieval call binding the contract method 0xe42c08f2.
//
// Solidity: function tokenBalanceOf(address owner) view returns(uint256)
func (_Heroticket *HeroticketCallerSession) TokenBalanceOf(owner common.Address) (*big.Int, error) {
	return _Heroticket.Contract.TokenBalanceOf(&_Heroticket.CallOpts, owner)
}

// BuyTicketByEther is a paid mutator transaction binding the contract method 0xc2b92c57.
//
// Solidity: function buyTicketByEther(address _ticketAddress) payable returns(uint256)
func (_Heroticket *HeroticketTransactor) BuyTicketByEther(opts *bind.TransactOpts, _ticketAddress common.Address) (*types.Transaction, error) {
	return _Heroticket.contract.Transact(opts, "buyTicketByEther", _ticketAddress)
}

// BuyTicketByEther is a paid mutator transaction binding the contract method 0xc2b92c57.
//
// Solidity: function buyTicketByEther(address _ticketAddress) payable returns(uint256)
func (_Heroticket *HeroticketSession) BuyTicketByEther(_ticketAddress common.Address) (*types.Transaction, error) {
	return _Heroticket.Contract.BuyTicketByEther(&_Heroticket.TransactOpts, _ticketAddress)
}

// BuyTicketByEther is a paid mutator transaction binding the contract method 0xc2b92c57.
//
// Solidity: function buyTicketByEther(address _ticketAddress) payable returns(uint256)
func (_Heroticket *HeroticketTransactorSession) BuyTicketByEther(_ticketAddress common.Address) (*types.Transaction, error) {
	return _Heroticket.Contract.BuyTicketByEther(&_Heroticket.TransactOpts, _ticketAddress)
}

// BuyTicketByToken is a paid mutator transaction binding the contract method 0x416af209.
//
// Solidity: function buyTicketByToken(address _ticketAddress, address _buyer) returns(uint256)
func (_Heroticket *HeroticketTransactor) BuyTicketByToken(opts *bind.TransactOpts, _ticketAddress common.Address, _buyer common.Address) (*types.Transaction, error) {
	return _Heroticket.contract.Transact(opts, "buyTicketByToken", _ticketAddress, _buyer)
}

// BuyTicketByToken is a paid mutator transaction binding the contract method 0x416af209.
//
// Solidity: function buyTicketByToken(address _ticketAddress, address _buyer) returns(uint256)
func (_Heroticket *HeroticketSession) BuyTicketByToken(_ticketAddress common.Address, _buyer common.Address) (*types.Transaction, error) {
	return _Heroticket.Contract.BuyTicketByToken(&_Heroticket.TransactOpts, _ticketAddress, _buyer)
}

// BuyTicketByToken is a paid mutator transaction binding the contract method 0x416af209.
//
// Solidity: function buyTicketByToken(address _ticketAddress, address _buyer) returns(uint256)
func (_Heroticket *HeroticketTransactorSession) BuyTicketByToken(_ticketAddress common.Address, _buyer common.Address) (*types.Transaction, error) {
	return _Heroticket.Contract.BuyTicketByToken(&_Heroticket.TransactOpts, _ticketAddress, _buyer)
}

// CreateTBA is a paid mutator transaction binding the contract method 0x9a827de5.
//
// Solidity: function createTBA(address to, string tokenURI) payable returns(uint256, address)
func (_Heroticket *HeroticketTransactor) CreateTBA(opts *bind.TransactOpts, to common.Address, tokenURI string) (*types.Transaction, error) {
	return _Heroticket.contract.Transact(opts, "createTBA", to, tokenURI)
}

// CreateTBA is a paid mutator transaction binding the contract method 0x9a827de5.
//
// Solidity: function createTBA(address to, string tokenURI) payable returns(uint256, address)
func (_Heroticket *HeroticketSession) CreateTBA(to common.Address, tokenURI string) (*types.Transaction, error) {
	return _Heroticket.Contract.CreateTBA(&_Heroticket.TransactOpts, to, tokenURI)
}

// CreateTBA is a paid mutator transaction binding the contract method 0x9a827de5.
//
// Solidity: function createTBA(address to, string tokenURI) payable returns(uint256, address)
func (_Heroticket *HeroticketTransactorSession) CreateTBA(to common.Address, tokenURI string) (*types.Transaction, error) {
	return _Heroticket.Contract.CreateTBA(&_Heroticket.TransactOpts, to, tokenURI)
}

// IssueTicket is a paid mutator transaction binding the contract method 0xc0fa772b.
//
// Solidity: function issueTicket(string ticketName, string ticketSymbol, string ticketUri, address issuer, uint256 ticketAmount, uint256 ticketEthPrice, uint256 ticketTokenPrice, uint256 saleDuration) returns(address)
func (_Heroticket *HeroticketTransactor) IssueTicket(opts *bind.TransactOpts, ticketName string, ticketSymbol string, ticketUri string, issuer common.Address, ticketAmount *big.Int, ticketEthPrice *big.Int, ticketTokenPrice *big.Int, saleDuration *big.Int) (*types.Transaction, error) {
	return _Heroticket.contract.Transact(opts, "issueTicket", ticketName, ticketSymbol, ticketUri, issuer, ticketAmount, ticketEthPrice, ticketTokenPrice, saleDuration)
}

// IssueTicket is a paid mutator transaction binding the contract method 0xc0fa772b.
//
// Solidity: function issueTicket(string ticketName, string ticketSymbol, string ticketUri, address issuer, uint256 ticketAmount, uint256 ticketEthPrice, uint256 ticketTokenPrice, uint256 saleDuration) returns(address)
func (_Heroticket *HeroticketSession) IssueTicket(ticketName string, ticketSymbol string, ticketUri string, issuer common.Address, ticketAmount *big.Int, ticketEthPrice *big.Int, ticketTokenPrice *big.Int, saleDuration *big.Int) (*types.Transaction, error) {
	return _Heroticket.Contract.IssueTicket(&_Heroticket.TransactOpts, ticketName, ticketSymbol, ticketUri, issuer, ticketAmount, ticketEthPrice, ticketTokenPrice, saleDuration)
}

// IssueTicket is a paid mutator transaction binding the contract method 0xc0fa772b.
//
// Solidity: function issueTicket(string ticketName, string ticketSymbol, string ticketUri, address issuer, uint256 ticketAmount, uint256 ticketEthPrice, uint256 ticketTokenPrice, uint256 saleDuration) returns(address)
func (_Heroticket *HeroticketTransactorSession) IssueTicket(ticketName string, ticketSymbol string, ticketUri string, issuer common.Address, ticketAmount *big.Int, ticketEthPrice *big.Int, ticketTokenPrice *big.Int, saleDuration *big.Int) (*types.Transaction, error) {
	return _Heroticket.Contract.IssueTicket(&_Heroticket.TransactOpts, ticketName, ticketSymbol, ticketUri, issuer, ticketAmount, ticketEthPrice, ticketTokenPrice, saleDuration)
}

// RenounceOwnership is a paid mutator transaction binding the contract method 0x715018a6.
//
// Solidity: function renounceOwnership() returns()
func (_Heroticket *HeroticketTransactor) RenounceOwnership(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Heroticket.contract.Transact(opts, "renounceOwnership")
}

// RenounceOwnership is a paid mutator transaction binding the contract method 0x715018a6.
//
// Solidity: function renounceOwnership() returns()
func (_Heroticket *HeroticketSession) RenounceOwnership() (*types.Transaction, error) {
	return _Heroticket.Contract.RenounceOwnership(&_Heroticket.TransactOpts)
}

// RenounceOwnership is a paid mutator transaction binding the contract method 0x715018a6.
//
// Solidity: function renounceOwnership() returns()
func (_Heroticket *HeroticketTransactorSession) RenounceOwnership() (*types.Transaction, error) {
	return _Heroticket.Contract.RenounceOwnership(&_Heroticket.TransactOpts)
}

// RequestTicketImage is a paid mutator transaction binding the contract method 0x22d472df.
//
// Solidity: function requestTicketImage(bytes encryptedSecretsUrls, string location, string keyword) returns(bytes32)
func (_Heroticket *HeroticketTransactor) RequestTicketImage(opts *bind.TransactOpts, encryptedSecretsUrls []byte, location string, keyword string) (*types.Transaction, error) {
	return _Heroticket.contract.Transact(opts, "requestTicketImage", encryptedSecretsUrls, location, keyword)
}

// RequestTicketImage is a paid mutator transaction binding the contract method 0x22d472df.
//
// Solidity: function requestTicketImage(bytes encryptedSecretsUrls, string location, string keyword) returns(bytes32)
func (_Heroticket *HeroticketSession) RequestTicketImage(encryptedSecretsUrls []byte, location string, keyword string) (*types.Transaction, error) {
	return _Heroticket.Contract.RequestTicketImage(&_Heroticket.TransactOpts, encryptedSecretsUrls, location, keyword)
}

// RequestTicketImage is a paid mutator transaction binding the contract method 0x22d472df.
//
// Solidity: function requestTicketImage(bytes encryptedSecretsUrls, string location, string keyword) returns(bytes32)
func (_Heroticket *HeroticketTransactorSession) RequestTicketImage(encryptedSecretsUrls []byte, location string, keyword string) (*types.Transaction, error) {
	return _Heroticket.Contract.RequestTicketImage(&_Heroticket.TransactOpts, encryptedSecretsUrls, location, keyword)
}

// TransferOwnership is a paid mutator transaction binding the contract method 0xf2fde38b.
//
// Solidity: function transferOwnership(address newOwner) returns()
func (_Heroticket *HeroticketTransactor) TransferOwnership(opts *bind.TransactOpts, newOwner common.Address) (*types.Transaction, error) {
	return _Heroticket.contract.Transact(opts, "transferOwnership", newOwner)
}

// TransferOwnership is a paid mutator transaction binding the contract method 0xf2fde38b.
//
// Solidity: function transferOwnership(address newOwner) returns()
func (_Heroticket *HeroticketSession) TransferOwnership(newOwner common.Address) (*types.Transaction, error) {
	return _Heroticket.Contract.TransferOwnership(&_Heroticket.TransactOpts, newOwner)
}

// TransferOwnership is a paid mutator transaction binding the contract method 0xf2fde38b.
//
// Solidity: function transferOwnership(address newOwner) returns()
func (_Heroticket *HeroticketTransactorSession) TransferOwnership(newOwner common.Address) (*types.Transaction, error) {
	return _Heroticket.Contract.TransferOwnership(&_Heroticket.TransactOpts, newOwner)
}

// UpdateWhiteList is a paid mutator transaction binding the contract method 0xe3bdcfd3.
//
// Solidity: function updateWhiteList(address _ticketAddress, address to) returns()
func (_Heroticket *HeroticketTransactor) UpdateWhiteList(opts *bind.TransactOpts, _ticketAddress common.Address, to common.Address) (*types.Transaction, error) {
	return _Heroticket.contract.Transact(opts, "updateWhiteList", _ticketAddress, to)
}

// UpdateWhiteList is a paid mutator transaction binding the contract method 0xe3bdcfd3.
//
// Solidity: function updateWhiteList(address _ticketAddress, address to) returns()
func (_Heroticket *HeroticketSession) UpdateWhiteList(_ticketAddress common.Address, to common.Address) (*types.Transaction, error) {
	return _Heroticket.Contract.UpdateWhiteList(&_Heroticket.TransactOpts, _ticketAddress, to)
}

// UpdateWhiteList is a paid mutator transaction binding the contract method 0xe3bdcfd3.
//
// Solidity: function updateWhiteList(address _ticketAddress, address to) returns()
func (_Heroticket *HeroticketTransactorSession) UpdateWhiteList(_ticketAddress common.Address, to common.Address) (*types.Transaction, error) {
	return _Heroticket.Contract.UpdateWhiteList(&_Heroticket.TransactOpts, _ticketAddress, to)
}

// HeroticketOwnershipTransferredIterator is returned from FilterOwnershipTransferred and is used to iterate over the raw logs and unpacked data for OwnershipTransferred events raised by the Heroticket contract.
type HeroticketOwnershipTransferredIterator struct {
	Event *HeroticketOwnershipTransferred // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *HeroticketOwnershipTransferredIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(HeroticketOwnershipTransferred)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(HeroticketOwnershipTransferred)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *HeroticketOwnershipTransferredIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *HeroticketOwnershipTransferredIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// HeroticketOwnershipTransferred represents a OwnershipTransferred event raised by the Heroticket contract.
type HeroticketOwnershipTransferred struct {
	PreviousOwner common.Address
	NewOwner      common.Address
	Raw           types.Log // Blockchain specific contextual infos
}

// FilterOwnershipTransferred is a free log retrieval operation binding the contract event 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0.
//
// Solidity: event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
func (_Heroticket *HeroticketFilterer) FilterOwnershipTransferred(opts *bind.FilterOpts, previousOwner []common.Address, newOwner []common.Address) (*HeroticketOwnershipTransferredIterator, error) {

	var previousOwnerRule []interface{}
	for _, previousOwnerItem := range previousOwner {
		previousOwnerRule = append(previousOwnerRule, previousOwnerItem)
	}
	var newOwnerRule []interface{}
	for _, newOwnerItem := range newOwner {
		newOwnerRule = append(newOwnerRule, newOwnerItem)
	}

	logs, sub, err := _Heroticket.contract.FilterLogs(opts, "OwnershipTransferred", previousOwnerRule, newOwnerRule)
	if err != nil {
		return nil, err
	}
	return &HeroticketOwnershipTransferredIterator{contract: _Heroticket.contract, event: "OwnershipTransferred", logs: logs, sub: sub}, nil
}

// WatchOwnershipTransferred is a free log subscription operation binding the contract event 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0.
//
// Solidity: event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
func (_Heroticket *HeroticketFilterer) WatchOwnershipTransferred(opts *bind.WatchOpts, sink chan<- *HeroticketOwnershipTransferred, previousOwner []common.Address, newOwner []common.Address) (event.Subscription, error) {

	var previousOwnerRule []interface{}
	for _, previousOwnerItem := range previousOwner {
		previousOwnerRule = append(previousOwnerRule, previousOwnerItem)
	}
	var newOwnerRule []interface{}
	for _, newOwnerItem := range newOwner {
		newOwnerRule = append(newOwnerRule, newOwnerItem)
	}

	logs, sub, err := _Heroticket.contract.WatchLogs(opts, "OwnershipTransferred", previousOwnerRule, newOwnerRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(HeroticketOwnershipTransferred)
				if err := _Heroticket.contract.UnpackLog(event, "OwnershipTransferred", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseOwnershipTransferred is a log parse operation binding the contract event 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0.
//
// Solidity: event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
func (_Heroticket *HeroticketFilterer) ParseOwnershipTransferred(log types.Log) (*HeroticketOwnershipTransferred, error) {
	event := new(HeroticketOwnershipTransferred)
	if err := _Heroticket.contract.UnpackLog(event, "OwnershipTransferred", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// HeroticketTBACreatedIterator is returned from FilterTBACreated and is used to iterate over the raw logs and unpacked data for TBACreated events raised by the Heroticket contract.
type HeroticketTBACreatedIterator struct {
	Event *HeroticketTBACreated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *HeroticketTBACreatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(HeroticketTBACreated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(HeroticketTBACreated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *HeroticketTBACreatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *HeroticketTBACreatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// HeroticketTBACreated represents a TBACreated event raised by the Heroticket contract.
type HeroticketTBACreated struct {
	Owner   common.Address
	Account common.Address
	TokenId *big.Int
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterTBACreated is a free log retrieval operation binding the contract event 0x99846f4a13095aea1fa388bfc0280cce1bba671fd6788b108d637ce604b6faaf.
//
// Solidity: event TBACreated(address indexed owner, address indexed account, uint256 tokenId)
func (_Heroticket *HeroticketFilterer) FilterTBACreated(opts *bind.FilterOpts, owner []common.Address, account []common.Address) (*HeroticketTBACreatedIterator, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}

	logs, sub, err := _Heroticket.contract.FilterLogs(opts, "TBACreated", ownerRule, accountRule)
	if err != nil {
		return nil, err
	}
	return &HeroticketTBACreatedIterator{contract: _Heroticket.contract, event: "TBACreated", logs: logs, sub: sub}, nil
}

// WatchTBACreated is a free log subscription operation binding the contract event 0x99846f4a13095aea1fa388bfc0280cce1bba671fd6788b108d637ce604b6faaf.
//
// Solidity: event TBACreated(address indexed owner, address indexed account, uint256 tokenId)
func (_Heroticket *HeroticketFilterer) WatchTBACreated(opts *bind.WatchOpts, sink chan<- *HeroticketTBACreated, owner []common.Address, account []common.Address) (event.Subscription, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}

	logs, sub, err := _Heroticket.contract.WatchLogs(opts, "TBACreated", ownerRule, accountRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(HeroticketTBACreated)
				if err := _Heroticket.contract.UnpackLog(event, "TBACreated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseTBACreated is a log parse operation binding the contract event 0x99846f4a13095aea1fa388bfc0280cce1bba671fd6788b108d637ce604b6faaf.
//
// Solidity: event TBACreated(address indexed owner, address indexed account, uint256 tokenId)
func (_Heroticket *HeroticketFilterer) ParseTBACreated(log types.Log) (*HeroticketTBACreated, error) {
	event := new(HeroticketTBACreated)
	if err := _Heroticket.contract.UnpackLog(event, "TBACreated", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// HeroticketTicketImageRequestCreatedIterator is returned from FilterTicketImageRequestCreated and is used to iterate over the raw logs and unpacked data for TicketImageRequestCreated events raised by the Heroticket contract.
type HeroticketTicketImageRequestCreatedIterator struct {
	Event *HeroticketTicketImageRequestCreated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *HeroticketTicketImageRequestCreatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(HeroticketTicketImageRequestCreated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(HeroticketTicketImageRequestCreated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *HeroticketTicketImageRequestCreatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *HeroticketTicketImageRequestCreatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// HeroticketTicketImageRequestCreated represents a TicketImageRequestCreated event raised by the Heroticket contract.
type HeroticketTicketImageRequestCreated struct {
	RequestId [32]byte
	Location  string
	Keyword   string
	Raw       types.Log // Blockchain specific contextual infos
}

// FilterTicketImageRequestCreated is a free log retrieval operation binding the contract event 0xa65f4c2bddbaa2fb5b8e03388cfd799b0402d2f3c92fc80b5f1c8f10922376e2.
//
// Solidity: event TicketImageRequestCreated(bytes32 indexed requestId, string location, string keyword)
func (_Heroticket *HeroticketFilterer) FilterTicketImageRequestCreated(opts *bind.FilterOpts, requestId [][32]byte) (*HeroticketTicketImageRequestCreatedIterator, error) {

	var requestIdRule []interface{}
	for _, requestIdItem := range requestId {
		requestIdRule = append(requestIdRule, requestIdItem)
	}

	logs, sub, err := _Heroticket.contract.FilterLogs(opts, "TicketImageRequestCreated", requestIdRule)
	if err != nil {
		return nil, err
	}
	return &HeroticketTicketImageRequestCreatedIterator{contract: _Heroticket.contract, event: "TicketImageRequestCreated", logs: logs, sub: sub}, nil
}

// WatchTicketImageRequestCreated is a free log subscription operation binding the contract event 0xa65f4c2bddbaa2fb5b8e03388cfd799b0402d2f3c92fc80b5f1c8f10922376e2.
//
// Solidity: event TicketImageRequestCreated(bytes32 indexed requestId, string location, string keyword)
func (_Heroticket *HeroticketFilterer) WatchTicketImageRequestCreated(opts *bind.WatchOpts, sink chan<- *HeroticketTicketImageRequestCreated, requestId [][32]byte) (event.Subscription, error) {

	var requestIdRule []interface{}
	for _, requestIdItem := range requestId {
		requestIdRule = append(requestIdRule, requestIdItem)
	}

	logs, sub, err := _Heroticket.contract.WatchLogs(opts, "TicketImageRequestCreated", requestIdRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(HeroticketTicketImageRequestCreated)
				if err := _Heroticket.contract.UnpackLog(event, "TicketImageRequestCreated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseTicketImageRequestCreated is a log parse operation binding the contract event 0xa65f4c2bddbaa2fb5b8e03388cfd799b0402d2f3c92fc80b5f1c8f10922376e2.
//
// Solidity: event TicketImageRequestCreated(bytes32 indexed requestId, string location, string keyword)
func (_Heroticket *HeroticketFilterer) ParseTicketImageRequestCreated(log types.Log) (*HeroticketTicketImageRequestCreated, error) {
	event := new(HeroticketTicketImageRequestCreated)
	if err := _Heroticket.contract.UnpackLog(event, "TicketImageRequestCreated", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// HeroticketTicketIssuedIterator is returned from FilterTicketIssued and is used to iterate over the raw logs and unpacked data for TicketIssued events raised by the Heroticket contract.
type HeroticketTicketIssuedIterator struct {
	Event *HeroticketTicketIssued // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *HeroticketTicketIssuedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(HeroticketTicketIssued)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(HeroticketTicketIssued)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *HeroticketTicketIssuedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *HeroticketTicketIssuedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// HeroticketTicketIssued represents a TicketIssued event raised by the Heroticket contract.
type HeroticketTicketIssued struct {
	TicketAddress    common.Address
	Owner            common.Address
	TicketName       string
	TicketSymbol     string
	TicketUri        string
	InitialOwner     common.Address
	TicketAmount     *big.Int
	TicketEthPrice   *big.Int
	TicketTokenPrice *big.Int
	SaleDuration     *big.Int
	Raw              types.Log // Blockchain specific contextual infos
}

// FilterTicketIssued is a free log retrieval operation binding the contract event 0xb68a2626e56537ae86f86105124fefc066702f3e0b088ab131b4432afdc60dc5.
//
// Solidity: event TicketIssued(address indexed _ticketAddress, address indexed _owner, string _ticketName, string _ticketSymbol, string _ticketUri, address _initialOwner, uint256 _ticketAmount, uint256 _ticketEthPrice, uint256 _ticketTokenPrice, uint256 _saleDuration)
func (_Heroticket *HeroticketFilterer) FilterTicketIssued(opts *bind.FilterOpts, _ticketAddress []common.Address, _owner []common.Address) (*HeroticketTicketIssuedIterator, error) {

	var _ticketAddressRule []interface{}
	for _, _ticketAddressItem := range _ticketAddress {
		_ticketAddressRule = append(_ticketAddressRule, _ticketAddressItem)
	}
	var _ownerRule []interface{}
	for _, _ownerItem := range _owner {
		_ownerRule = append(_ownerRule, _ownerItem)
	}

	logs, sub, err := _Heroticket.contract.FilterLogs(opts, "TicketIssued", _ticketAddressRule, _ownerRule)
	if err != nil {
		return nil, err
	}
	return &HeroticketTicketIssuedIterator{contract: _Heroticket.contract, event: "TicketIssued", logs: logs, sub: sub}, nil
}

// WatchTicketIssued is a free log subscription operation binding the contract event 0xb68a2626e56537ae86f86105124fefc066702f3e0b088ab131b4432afdc60dc5.
//
// Solidity: event TicketIssued(address indexed _ticketAddress, address indexed _owner, string _ticketName, string _ticketSymbol, string _ticketUri, address _initialOwner, uint256 _ticketAmount, uint256 _ticketEthPrice, uint256 _ticketTokenPrice, uint256 _saleDuration)
func (_Heroticket *HeroticketFilterer) WatchTicketIssued(opts *bind.WatchOpts, sink chan<- *HeroticketTicketIssued, _ticketAddress []common.Address, _owner []common.Address) (event.Subscription, error) {

	var _ticketAddressRule []interface{}
	for _, _ticketAddressItem := range _ticketAddress {
		_ticketAddressRule = append(_ticketAddressRule, _ticketAddressItem)
	}
	var _ownerRule []interface{}
	for _, _ownerItem := range _owner {
		_ownerRule = append(_ownerRule, _ownerItem)
	}

	logs, sub, err := _Heroticket.contract.WatchLogs(opts, "TicketIssued", _ticketAddressRule, _ownerRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(HeroticketTicketIssued)
				if err := _Heroticket.contract.UnpackLog(event, "TicketIssued", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseTicketIssued is a log parse operation binding the contract event 0xb68a2626e56537ae86f86105124fefc066702f3e0b088ab131b4432afdc60dc5.
//
// Solidity: event TicketIssued(address indexed _ticketAddress, address indexed _owner, string _ticketName, string _ticketSymbol, string _ticketUri, address _initialOwner, uint256 _ticketAmount, uint256 _ticketEthPrice, uint256 _ticketTokenPrice, uint256 _saleDuration)
func (_Heroticket *HeroticketFilterer) ParseTicketIssued(log types.Log) (*HeroticketTicketIssued, error) {
	event := new(HeroticketTicketIssued)
	if err := _Heroticket.contract.UnpackLog(event, "TicketIssued", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// HeroticketTicketSoldIterator is returned from FilterTicketSold and is used to iterate over the raw logs and unpacked data for TicketSold events raised by the Heroticket contract.
type HeroticketTicketSoldIterator struct {
	Event *HeroticketTicketSold // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *HeroticketTicketSoldIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(HeroticketTicketSold)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(HeroticketTicketSold)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *HeroticketTicketSoldIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *HeroticketTicketSoldIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// HeroticketTicketSold represents a TicketSold event raised by the Heroticket contract.
type HeroticketTicketSold struct {
	TicketAddress common.Address
	Buyer         common.Address
	TicketId      *big.Int
	SaleType      uint8
	Raw           types.Log // Blockchain specific contextual infos
}

// FilterTicketSold is a free log retrieval operation binding the contract event 0x1e4e0bc720755ad50b7af8209717b1f6044596f0ef3f0bac4908cfe59d1104f3.
//
// Solidity: event TicketSold(address indexed _ticketAddress, address indexed _buyer, uint256 _ticketId, uint8 _saleType)
func (_Heroticket *HeroticketFilterer) FilterTicketSold(opts *bind.FilterOpts, _ticketAddress []common.Address, _buyer []common.Address) (*HeroticketTicketSoldIterator, error) {

	var _ticketAddressRule []interface{}
	for _, _ticketAddressItem := range _ticketAddress {
		_ticketAddressRule = append(_ticketAddressRule, _ticketAddressItem)
	}
	var _buyerRule []interface{}
	for _, _buyerItem := range _buyer {
		_buyerRule = append(_buyerRule, _buyerItem)
	}

	logs, sub, err := _Heroticket.contract.FilterLogs(opts, "TicketSold", _ticketAddressRule, _buyerRule)
	if err != nil {
		return nil, err
	}
	return &HeroticketTicketSoldIterator{contract: _Heroticket.contract, event: "TicketSold", logs: logs, sub: sub}, nil
}

// WatchTicketSold is a free log subscription operation binding the contract event 0x1e4e0bc720755ad50b7af8209717b1f6044596f0ef3f0bac4908cfe59d1104f3.
//
// Solidity: event TicketSold(address indexed _ticketAddress, address indexed _buyer, uint256 _ticketId, uint8 _saleType)
func (_Heroticket *HeroticketFilterer) WatchTicketSold(opts *bind.WatchOpts, sink chan<- *HeroticketTicketSold, _ticketAddress []common.Address, _buyer []common.Address) (event.Subscription, error) {

	var _ticketAddressRule []interface{}
	for _, _ticketAddressItem := range _ticketAddress {
		_ticketAddressRule = append(_ticketAddressRule, _ticketAddressItem)
	}
	var _buyerRule []interface{}
	for _, _buyerItem := range _buyer {
		_buyerRule = append(_buyerRule, _buyerItem)
	}

	logs, sub, err := _Heroticket.contract.WatchLogs(opts, "TicketSold", _ticketAddressRule, _buyerRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(HeroticketTicketSold)
				if err := _Heroticket.contract.UnpackLog(event, "TicketSold", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseTicketSold is a log parse operation binding the contract event 0x1e4e0bc720755ad50b7af8209717b1f6044596f0ef3f0bac4908cfe59d1104f3.
//
// Solidity: event TicketSold(address indexed _ticketAddress, address indexed _buyer, uint256 _ticketId, uint8 _saleType)
func (_Heroticket *HeroticketFilterer) ParseTicketSold(log types.Log) (*HeroticketTicketSold, error) {
	event := new(HeroticketTicketSold)
	if err := _Heroticket.contract.UnpackLog(event, "TicketSold", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// HeroticketTokenPaymentForIssueTicketIterator is returned from FilterTokenPaymentForIssueTicket and is used to iterate over the raw logs and unpacked data for TokenPaymentForIssueTicket events raised by the Heroticket contract.
type HeroticketTokenPaymentForIssueTicketIterator struct {
	Event *HeroticketTokenPaymentForIssueTicket // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *HeroticketTokenPaymentForIssueTicketIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(HeroticketTokenPaymentForIssueTicket)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(HeroticketTokenPaymentForIssueTicket)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *HeroticketTokenPaymentForIssueTicketIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *HeroticketTokenPaymentForIssueTicketIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// HeroticketTokenPaymentForIssueTicket represents a TokenPaymentForIssueTicket event raised by the Heroticket contract.
type HeroticketTokenPaymentForIssueTicket struct {
	Issuer           common.Address
	TicketTokenPrice *big.Int
	Raw              types.Log // Blockchain specific contextual infos
}

// FilterTokenPaymentForIssueTicket is a free log retrieval operation binding the contract event 0x59efabaa79c4e0cc241af94aaa1ee64d5230d63a8db41eb2b33342c69ba11cce.
//
// Solidity: event TokenPaymentForIssueTicket(address indexed _issuer, uint256 _ticketTokenPrice)
func (_Heroticket *HeroticketFilterer) FilterTokenPaymentForIssueTicket(opts *bind.FilterOpts, _issuer []common.Address) (*HeroticketTokenPaymentForIssueTicketIterator, error) {

	var _issuerRule []interface{}
	for _, _issuerItem := range _issuer {
		_issuerRule = append(_issuerRule, _issuerItem)
	}

	logs, sub, err := _Heroticket.contract.FilterLogs(opts, "TokenPaymentForIssueTicket", _issuerRule)
	if err != nil {
		return nil, err
	}
	return &HeroticketTokenPaymentForIssueTicketIterator{contract: _Heroticket.contract, event: "TokenPaymentForIssueTicket", logs: logs, sub: sub}, nil
}

// WatchTokenPaymentForIssueTicket is a free log subscription operation binding the contract event 0x59efabaa79c4e0cc241af94aaa1ee64d5230d63a8db41eb2b33342c69ba11cce.
//
// Solidity: event TokenPaymentForIssueTicket(address indexed _issuer, uint256 _ticketTokenPrice)
func (_Heroticket *HeroticketFilterer) WatchTokenPaymentForIssueTicket(opts *bind.WatchOpts, sink chan<- *HeroticketTokenPaymentForIssueTicket, _issuer []common.Address) (event.Subscription, error) {

	var _issuerRule []interface{}
	for _, _issuerItem := range _issuer {
		_issuerRule = append(_issuerRule, _issuerItem)
	}

	logs, sub, err := _Heroticket.contract.WatchLogs(opts, "TokenPaymentForIssueTicket", _issuerRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(HeroticketTokenPaymentForIssueTicket)
				if err := _Heroticket.contract.UnpackLog(event, "TokenPaymentForIssueTicket", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseTokenPaymentForIssueTicket is a log parse operation binding the contract event 0x59efabaa79c4e0cc241af94aaa1ee64d5230d63a8db41eb2b33342c69ba11cce.
//
// Solidity: event TokenPaymentForIssueTicket(address indexed _issuer, uint256 _ticketTokenPrice)
func (_Heroticket *HeroticketFilterer) ParseTokenPaymentForIssueTicket(log types.Log) (*HeroticketTokenPaymentForIssueTicket, error) {
	event := new(HeroticketTokenPaymentForIssueTicket)
	if err := _Heroticket.contract.UnpackLog(event, "TokenPaymentForIssueTicket", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// HeroticketTokenRewardIterator is returned from FilterTokenReward and is used to iterate over the raw logs and unpacked data for TokenReward events raised by the Heroticket contract.
type HeroticketTokenRewardIterator struct {
	Event *HeroticketTokenReward // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *HeroticketTokenRewardIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(HeroticketTokenReward)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(HeroticketTokenReward)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *HeroticketTokenRewardIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *HeroticketTokenRewardIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// HeroticketTokenReward represents a TokenReward event raised by the Heroticket contract.
type HeroticketTokenReward struct {
	To     common.Address
	Amount *big.Int
	Raw    types.Log // Blockchain specific contextual infos
}

// FilterTokenReward is a free log retrieval operation binding the contract event 0x395c411eb901f31b59d14e8279edd4fa68fbe920fad004145896160eaff413b4.
//
// Solidity: event TokenReward(address to, uint256 amount)
func (_Heroticket *HeroticketFilterer) FilterTokenReward(opts *bind.FilterOpts) (*HeroticketTokenRewardIterator, error) {

	logs, sub, err := _Heroticket.contract.FilterLogs(opts, "TokenReward")
	if err != nil {
		return nil, err
	}
	return &HeroticketTokenRewardIterator{contract: _Heroticket.contract, event: "TokenReward", logs: logs, sub: sub}, nil
}

// WatchTokenReward is a free log subscription operation binding the contract event 0x395c411eb901f31b59d14e8279edd4fa68fbe920fad004145896160eaff413b4.
//
// Solidity: event TokenReward(address to, uint256 amount)
func (_Heroticket *HeroticketFilterer) WatchTokenReward(opts *bind.WatchOpts, sink chan<- *HeroticketTokenReward) (event.Subscription, error) {

	logs, sub, err := _Heroticket.contract.WatchLogs(opts, "TokenReward")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(HeroticketTokenReward)
				if err := _Heroticket.contract.UnpackLog(event, "TokenReward", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseTokenReward is a log parse operation binding the contract event 0x395c411eb901f31b59d14e8279edd4fa68fbe920fad004145896160eaff413b4.
//
// Solidity: event TokenReward(address to, uint256 amount)
func (_Heroticket *HeroticketFilterer) ParseTokenReward(log types.Log) (*HeroticketTokenReward, error) {
	event := new(HeroticketTokenReward)
	if err := _Heroticket.contract.UnpackLog(event, "TokenReward", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
