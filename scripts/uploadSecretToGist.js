const {
    SecretsManager,
    createGist,
} = require("@chainlink/functions-toolkit");
const ethers = require("ethers");
require("dotenv").config();
const fs = require("fs");
const os = require("os");

// hardcoded for Polygon Mumbai
const routerAddress = "0x6E2dc0F9DB014aE19888F539E59285D2Ea04244C";
const donId = "fun-polygon-mumbai-1";


const uploadSecretToGist = async () => {
    const privateKey = process.env.MUMBAI_PRIVATE_KEY;
    const rpcUrl = process.env.MUMBAI_RPC_ENDPOINT;

    const provider = new ethers.providers.JsonRpcProvider(rpcUrl);
    const wallet = new ethers.Wallet(privateKey);
    const signer = wallet.connect(provider);

    const secrets = { apiKey: process.env.OPENAI_API_KEY };

    console.log("secrets: ", secrets);

    const secretsManager = new SecretsManager({
        signer: signer,
        functionsRouterAddress: routerAddress,
        donId: donId,
    });
    await secretsManager.initialize();

    const encryptedSecretObj = await secretsManager.encryptSecrets(secrets);

    const githubApiToken = process.env.GITHUB_API_TOKEN;

    const gistURL = await createGist(
        githubApiToken,
        JSON.stringify(encryptedSecretObj)
    );

    console.log("Gist URL: ", gistURL);

    const encryptedSecretUrls = await secretsManager.encryptSecretsUrls([gistURL]);


    const envVars = fs.readFileSync(process.cwd() + "/.env", "utf8").split(os.EOL);

    // .env 파일에서 GIST_URL 찾기
    const index = envVars.findIndex((line) => line.includes("GIST_URL"));

    // GIST_URL이 없으면 추가, 있으면 덮어쓰기
    if (index === -1) {
        envVars.push(`GIST_URL=${gistURL}`);
    } else {
        envVars.splice(index, 1, `GIST_URL=${gistURL}`);
    }

    // .env 파일에서 ENCRYPTED_SECRET_URLS 찾기
    const index2 = envVars.findIndex((line) => line.includes("ENCRYPTED_SECRET_URLS"));

    // ENCRYPTED_SECRET_URLS이 없으면 추가, 있으면 덮어쓰기
    if (index2 === -1) {
        envVars.push(`ENCRYPTED_SECRET_URLS=${encryptedSecretUrls}`);
    } else {
        envVars.splice(index2, 1, `ENCRYPTED_SECRET_URLS=${encryptedSecretUrls}`);
    }

    // .env 파일 덮어쓰기
    fs.writeFileSync(process.cwd() + "/.env", envVars.join(os.EOL));
}

uploadSecretToGist().then(() => {
    console.log("Done");
    process.exit(0);
}).catch((err) => {
    console.error(err);
    process.exit(1);
});
