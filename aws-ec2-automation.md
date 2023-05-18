# AWS EC2 App Deployment Automation

This guide outlines how automate all of the previous steps to create a web app automatically on start-up using a provisioning script that can be copied into the 'User data' section in 'Advanced details' when creating an EC2 instance. The provisioning script should look similar to the file [here](https://github.com/bradley-woods/tech230-aws/blob/main/provision-app.sh) which automates the deployment of the sample app.

## Instructions to a Provisioning Script

1. Firstly, create a shell script file (e.g. app-provision.sh) and enter the following line at the beginning. `#!/bin/bash` is called a Shebang and tells the shell that this script should be run using the bash (Bourne Again Shell) interpreter:

    ```bash
    #!/bin/bash
    ```

2. Secondly, the bash shell should update the list of packages and upgrade them (using `-y` to bypass any warnings or user prompts):

    ```bash
    # Update and upgrade packages
    sudo apt-get update -y
    sudo apt-get upgrade -y
    ```

3. Now we need to install Nginx using the following command, by default it should be running:

    ```bash
    # Install nginx web server
    sudo apt-get install nginx -y
    ```

4. Next, we can edit and replace the default Nginx configuration file to set it up as a reverse proxy which listens on port 80 (HTTP) and passes on requests to the localhost:3000 port when the public IP is requested of the app server. Also, it should pass the requests to localhost:3000/posts when '/posts' is requested. The `echo` command is piped with a `sudo` command to ensure it has the correct permissions to edit the config file (e.g. root user):

    ```bash
    # Replace default config file
    echo "
    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        server_name _;

        location / {
            proxy_pass http://localhost:3000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host \$host;
            proxy_cache_bypass \$http_upgrade;
        }

        location /posts {
            proxy_pass http://localhost:3000/posts;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host \$host;
            proxy_cache_bypass \$http_upgrade;
        }
    }" | sudo tee /etc/nginx/sites-available/default
    ```

5. Then the script restarts the Nginx web server using `restart` since we changed the configuration file, and `enable` tells the service to stay running even if it is rebooted, it'll know to run the service:

    ```bash
    # Restart nginx web server
    sudo systemctl restart nginx

    # Keep it running on reboot
    sudo systemctl enable nginx
    ```

6. The next step is to ensure the script installs all of the app dependencies, such as NodeJS and Process Manager, as follows:

    ```bash
    # Install app dependencies
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
    sudo apt-get install nodejs -y
    sudo npm install pm2 -g
    ```

7. The script then adds the `DB_HOST` environment variable to the `.bashrc` configuration file so bash will keep this file persistent so the app can use it to retrieve contents from the MongoDB database:

    ```bash
    # Add database host IP info to .bashrc
    echo -e "\nexport DB_HOST=mongodb://<ip-address>:27017/posts" | sudo tee -a .bashrc
    source .bashrc
    ```

8. Next, a folder called 'repo' is created and the required app folder is downloaded from GitHub repo through cloning it:

    ```bash
    # Get repo with app folder
    mkdir ~/repo
    git clone https://github.com/bradley-woods/tech230-aws.git ~/repo
    ```

9. Now we have the app folder, the script `cd` changes directory inside the app folder and installs it using the following commands:

    ```bash
    # Install the app
    cd ~/repo/app
    sudo npm install
    ```

10. Assuming the database server is up and running, the script will seed and clear the database:

    ```bash
    # Seed the database
    node seeds/seed.js
    ```

11. Finally, the app is started and the new environment variable is updated if needed. If the app is already started for a particular reason, the second command restarts it and flushes through the environment variable:

    ```bash
    # Start the app
    pm2 start app.js --update-env
    ```

    ```bash
    # If already started, restart (idempotence)
    pm2 restart app.js --update-env
    ```

12. The app should now be running on the public IP address without needing to add ':3000' port number as the Nginx server has been set up as a reverse proxy:

    ![Node app running](images/node-running.png)

13. The script was run multiple times in the terminal using `./provision-app.sh` ensuring the correct permissions were set, and it still ran smoothly and a running app was produced at the end of it, to ensure the script was idempotent:

    ![Sample app running in browser](images/aws-app-page.png)

14. The next steps would be to copy and paste the provisioning script into the 'User data' section under 'Advanced details' when launching an EC2 instance, so the sample app will be up and running when it has initialised.
