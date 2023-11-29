const requestId = args[0];
const location = args[1];
const keyword = args[2];

const prompt = `Please create an image of a ticket for the event "${keyword}" at "${location}`;

const openaiApiKey = secrets.openaiApiKey || '';

if (!openaiApiKey) {
  throw Error('openaiApiKey is not set');
}

const pinataJwt = secrets.pinataJwt || '';

if (!pinataJwt) {
  throw Error('pinataJwt is not set');
}

const openAIRequest = Functions.makeHttpRequest({
  url: 'https://api.openai.com/v1/images/generations',
  method: 'POST',
  headers: {
    Authorization: `Bearer ${openaiApiKey}`,
    'Content-Type': 'application/json',
  },
  data: { model: 'dall-e-2', prompt: prompt, size: '256x256' },
  timeout: 9000,
});

const openAiResponse = await openAIRequest;
if (openAiResponse.error) {
  throw Error(
    openAiResponse.error.message
      ? openAiResponse.error.message
      : 'openai response error'
  );
}

const data = openAiResponse.data;

if (!data || !data.data) {
  throw Error('No data in response');
}

const imageUrl = data.data[0].url;

console.log('image url:', imageUrl);

// ipfs에 업로드
const ipfsPinRequest = Functions.makeHttpRequest({
  url: 'https://api.pinata.cloud/pinning/pinJSONToIPFS',
  method: 'POST',
  headers: {
    Authorization: `Bearer ${pinataJwt} `,
    'Content-Type': 'application/json',
  },
  data: {
    pinataContent: {
      url: imageUrl,
    },
    pinataMetadata: {
      name: `${requestId}.json`,
      keyvalues: {
        keyword: keyword,
        location: location,
      },
    },
  },
  timeout: 9000,
});

const ipfsPinResponse = await ipfsPinRequest;
if (ipfsPinResponse.error) {
  throw Error(
    ipfsPinResponse.error.details
      ? ipfsPinResponse.error.details
      : 'ipfs pin response error'
  );
}

const ipfsData = ipfsPinResponse.data;

if (!ipfsData) {
  throw Error('No data in response');
}

const ipfsHash = ipfsData.IpfsHash;

console.log('IpfsHash:', ipfsHash);

return Functions.encodeString(ipfsHash);
