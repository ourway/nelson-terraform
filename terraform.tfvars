startup_script = <<-EOF
sudo apt-get update;
sudo apt-get upgrade -y;
sudo apt-get install -yq build-essential python-pip rsync;
pip install flask;
EOF

credentials = "/Users/farshid.ashouri/credentials/rodmena-f3466bcb23e5.json"
public_key  = "/Users/farshid.ashouri/.ssh/id_rsa.pub"

