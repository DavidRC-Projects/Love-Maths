FROM gitpod/workspace-full

USER root
# Setup Heroku CLI
RUN curl https://cli-assets.heroku.com/install.sh | sh

# Setup MongoDB and MySQL
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 20691eec35216c63caf66ce1656408e390cfb1f5 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list  && \
    apt-get update -y  && \
    touch /etc/init.d/mongod  && \
    apt-get -y install mongodb-org-shell -y  && \
    apt-get -y install links  && \
    apt-get install -y mysql-server && \
    apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/* && \
    mkdir /var/run/mysqld && \
    chown -R gitpod:gitpod /etc/mysql /var/run/mysqld /var/log/mysql /var/lib/mysql /var/lib/mysql-files /var/lib/mysql-keyring /var/lib/mysql-upgrade /home/gitpod/.cache/heroku/ && \
    pip3 install flake8 flake8-flask flake8-django

# Create our own config files

COPY .theia/mysql.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

COPY .theia/client.cnf /etc/mysql/mysql.conf.d/client.cnf

COPY .theia/start_mysql.sh /etc/mysql/mysql-bashrc-launch.sh

USER gitpod

# Start MySQL when we log in
