ssh-keygen -f '/root/.ssh/known_hosts' -R 'your_ip'
rsync -avz /website_backups/postgres your_ip:/website_backups
your_password
