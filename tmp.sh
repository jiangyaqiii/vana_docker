# 生成加密密钥
./keygen.sh

# 将公钥写入 .env 文件
PUBLIC_KEY_FILE="/root/vana-dlp-chatgpt/public_key_base64.asc"
ENV_FILE="/root/vana-dlp-chatgpt/.env"

# 检查公钥文件是否存在
if [ ! -f "$PUBLIC_KEY_FILE" ]; then
    echo "公钥文件不存在: $PUBLIC_KEY_FILE"
    exit 1
fi

# 读取公钥内容
PUBLIC_KEY=$(cat "$PUBLIC_KEY_FILE")

# 将公钥写入 .env 文件
echo "PRIVATE_FILE_ENCRYPTION_PUBLIC_KEY_BASE64=\"$PUBLIC_KEY\"" >> "$ENV_FILE"

echo "公钥已成功写入到 .env 文件中。"

# 部署智能合约
cd $HOME
git clone https://github.com/Josephtran102/vana-dlp-smart-contracts
cd vana-dlp-smart-contracts
npm install -g yarn
yarn install
cp .env.example .env
nano .env  # 手动编辑 .env 文件
npx hardhat deploy --network moksha --tags DLPDeploy

# 注册验证器
cd $HOME
cd vana-dlp-chatgpt

# 创建 .env 文件
echo "创建 .env 文件..."
read -p "请输入 DLP 合约地址: " DLP_CONTRACT
read -p "请输入 DLP Token 合约地址: " DLP_TOKEN_CONTRACT
read -p "请输入 OpenAI API Key: " OPENAI_API_KEY

cat <<EOF > /root/vana-dlp-chatgpt/.env
# The network to use, currently Vana Moksha testnet
OD_CHAIN_NETWORK=moksha
OD_CHAIN_NETWORK_ENDPOINT=https://rpc.moksha.vana.org

# Optional: OpenAI API key for additional data quality check
OPENAI_API_KEY="$OPENAI_API_KEY"

# Optional: Your own DLP smart contract address once deployed to the network, useful for local testing
DLP_MOKSHA_CONTRACT="$DLP_CONTRACT"

# Optional: Your own DLP token contract address once deployed to the network, useful for local testing
DLP_TOKEN_MOKSHA_CONTRACT="$DLP_TOKEN_CONTRACT"
EOF
./vanacli dlp register_validator --stake_amount 10
read -p "请输入您的 Hotkey 钱包地址: " HOTKEY_ADDRESS
./vanacli dlp approve_validator --validator_address="$HOTKEY_ADDRESS"

python -m chatgpt.nodes.validator

'
echo "DLP Validator 容器已启动并在后台运行。"
echo "要进入容器，请使用命令: docker exec -it dlp-validator-container /bin/bash"
