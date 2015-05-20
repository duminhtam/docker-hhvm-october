FROM ubuntu:trusty
MAINTAINER DU MINH TAM <duminhtam@gmail.com>

RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
    echo 'deb http://mirrors.syringanetworks.net/mariadb/repo/10.1/ubuntu trusty main' >> /etc/apt/sources.list && \
    echo 'deb-src http://mirrors.syringanetworks.net/mariadb/repo/10.1/ubuntu trusty main' >> /etc/apt/sources.list && \
    apt-get update && \
    sudo apt-get install -y unzip vim git-core curl wget build-essential python-software-properties && \
    sudo add-apt-repository -y ppa:nginx/stable && \
    sudo apt-get update && \
    sudo apt-get install -y nginx && \
    wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add - && \
    echo deb http://dl.hhvm.com/ubuntu trusty main | sudo tee /etc/apt/sources.list.d/hhvm.list && \
    sudo apt-get update && \
    sudo apt-get install -y hhvm && \
    sudo /usr/share/hhvm/install_fastcgi.sh && \
    sudo /etc/init.d/nginx restart && \
    sudo /etc/init.d/hhvm restart && \
    sudo /usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60 && \
    sudo /usr/share/hhvm/install_fastcgi.sh && \
    sudo update-rc.d hhvm defaults && \
    sudo service hhvm restart && \

    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN rm -rf /etc/nginx/sites-available/default

ADD default /etc/nginx/sites-available/default

# Add VOLUMEs to allow store web data
VOLUME  ["/usr/share/nginx/"]

EXPOSE 80
EXPOSE 443
