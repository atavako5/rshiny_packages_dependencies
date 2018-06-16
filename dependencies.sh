#!/bin/bash
sudo echo "deb http://stat.ethz.ch/CRAN/bin/linux/ubuntu xenial/ #enabled-manually" >> /etc/apt/sources.list
sudo apt-get update


## ADD MORE DEPENDENCIES TO THE END OF THIS LINE
REQPKGS=(sudo pandoc-citeproc \
             libxt-dev \ 
             libssl-dev \
             cmake \
             libcurl4-openssl-dev \
             libnlopt-dev \
             libwebp-dev \
             libpoppler-cpp-dev \
             libleptonica-dev \
             libtesseract-dev \
             pkg-config \
             tesseract-ocr-eng \
             libglu1-mesa-dev \
             freeglut3-dev \
             mesa-common-dev \
             bwidget \
             xorg \
             libx11-dev \
             xquartz \
             libcurl4-gnutls-dev \
             libxml2-dev \
             libssl-dev \
             nginx \
             software-properties-common \
             python-software-properties \
             libwebp-dev \
             libpoppler-cpp-dev \
             libfreetype6-dev \
        #>>>>>>>>>>>>>X add the dependencies/libraries you need for your packages here 
        #               seperate them by "<space> \" so it would be like the 4 lines above but keep everything in the round brackets
        ) # <<<< Do not remove me

sudo apt-get update -y && sudo apt-get upgrade -y&& sudo apt-get dist-upgrade -y

# you can also install dependencies the same way as below but running: sudo apt-get install package_name_1 package_name_2 package_name_3 -y
# The y at the end make sures that the packages will run headless and won't ask for confirmation where you can't provide one

sudo apt-get install r-base r-base-dev -y


# Don't mess with anything below this line unless you know what you are doing

for pkg in "${REQPKGS[@]}"; do
    if apt -q list --installed "$pkg" > /dev/null 2>&1; then
        echo -e "$pkg is already installed"
    else
        sudo apt-get install "$pkg" -y && echo "Successfully installed $pkg"
    fi
done
