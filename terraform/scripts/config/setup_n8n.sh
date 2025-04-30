curl -L      | sh
#!/bin/bash
echo "--------- 🟢 Start install docker -----------"
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install -y docker-ce
echo "--------- 🔴 Finish install docker -----------"
echo "--------- 🟢 Start creating folder -----------"
cd ~
mkdir vol_n8n
sudo chown -R 1000:1000 vol_n8n
sudo chmod -R 755 vol_n8n
echo "--------- 🔴 Finish creating folder -----------"
echo "--------- 🟢 Start docker compose up  -----------"
wget https://raw.githubusercontent.com/thangnch/MIAI_n8n_dockercompose/refs/heads/main/compose_noai.yaml -O compose.yaml
export EXTERNAL_IP=http://"$(hostname -I | cut -f1 -d' ')"
export CURR_DIR=$(pwd)
sudo -E docker compose up -d
echo "--------- 🔴 Finish! Wait a few minutes and test in browser at url $EXTERNAL_IP for n8n UI -----------"




sh <(curl -L https://bit.ly/n8n_with_ngrok)

#!/bin/bash                                                                                sngrok.sh                                                                                                  
echo "--------- 🟢 Start Docker compose down  -----------"
sudo -E docker compose down
echo "--------- 🔴 Finish Docker compose down -----------"
echo "--------- 🟢 Start Ngrok setup -----------"
wget -O ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
sudo tar xvzf ./ngrok.tgz -C /usr/local/bin
sudo apt install -y jq
echo "🔴🔴🔴 Please login into ngrok.com and paste your token and static URL here:"
read -p "Token : " token
read -p "Domain : " domain
ngrok config add-authtoken $token
ngrok http --url=$domain 80 > /dev/null &
echo "🔴🔴🔴 Please wait Ngrok to start...."
sleep 8
export EXTERNAL_IP="$(curl http://localhost:4040/api/tunnels | jq ".tunnels[0].public_url")"
echo Got Ngrok URL = $EXTERNAL_IP
echo "--------- 🔴 Finish Ngrok setup -----------"
echo "--------- 🟢 Start Docker compose up  -----------"
sudo -E docker compose up -d
echo "--------- 🔴 Finish! Wait a few minutes and test in browser at url $EXTERNAL_IP for n8n UI -----------"


Token : 2vAQrlh0O9rexvVrdzVDJXGO0q9_7GZN787jA91vfApjZSioC
Domain : good-sensibly-pug.ngrok-free.app
curl -L https://bit.ly/n8n_install_noai | sh
Sau đó lấy ip đó
