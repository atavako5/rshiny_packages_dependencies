# Shiny-server with persistant package-manager and dependencies for those packges

##### I made this image out of frustration because I could not find an image that I needed for a very complicated shiny web application with many packages and dependencies for those pacakges.

##### But fear not, this image is very easy to use and intuitive, so you won't have to go through the same frustration as I did

#####  --- This Image is based on ubuntu 16.04 so its not for small shiny-server deployment, it should be used for large shiny-server web applications. If I get enough requests I will make it on an alpine image so the image size will be smaller.



## [Optional Requires Image Rebuild] First you need to make a dependencies shell file, lets call it 



> dependencies.sh



### and include it in the a folder where you want the docker-compose file to be.
##### easiest way is to just follow this example and add your dependencies in the places with the comment '>>>>X' :

	#!/bin/bash
	sudo echo  "deb http://stat.ethz.ch/CRAN/bin/linux/ubuntu xenial/ #enabled-manually" >> /etc/apt/sources.list
	sudo apt-get update
	
	# ADD MORE DEPENDENCIES TO THE END OF THIS LINE
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
				  
				  #>>>>X add the dependencies/libraries you need for your packages here
				  
				  #seperate them by "<space> \" so it would be like the 4 lines above but keep everything in the round brackets
			 ) # <<<< Do not remove me

	sudo apt-get update -y && sudo apt-get upgrade -y&& sudo apt-get dist-upgrade -y
	
	# >>>>X you can also install dependencies the same way as below but running: sudo apt-get install package_name_1 package_name_2 package_name_3 -y
	
	sudo apt-get install r-base r-base-dev -y 
	
	# The y at the end make sures that the packages will run headless and won't ask for confirmation where you can't provide one
	
	# Don't mess with anything below this line unless you know what you are doing
	for  pkg  in  "${REQPKGS[@]}";  do
		if apt -q list --installed "$pkg"  > /dev/null 2>&1;  then
			echo -e "$pkg is already installed"
		else
			sudo apt-get install "$pkg" -y &&  echo  "Successfully installed $pkg"
		fi
	done
### As you can see from the file above, this step is entirely optional because I've already installed a lot of dependencies for major packages that you might need so don't worry about it unless you know you need a certain dependency




## Now lets make a file to install all those pesky R-Packages at once



### Make the following file in the same directory as you would put the Docker Compose file -- or any directory you want, but its easier if its in the same directory --
> packageInstaller.R
### Paste the following in the packageInstaller.R file and add or remove packages as you wish
	pkgTest  <-  function(x)
	{
	if (!require(x,character.only  =  TRUE))
	{
		install.packages(x,dep=TRUE,repos  =  "http://cran.r-project.org")
		if(!require(x,character.only  =  TRUE)) stop("Package not found")
		}
	}
	packages  =  c(
	"sourcetools",
	"xlsx",
	"Cairo",
	"R6",
	"DT",
	"shinythemes",
	"shinydashboard",
	"shiny",
	"shinyjs",
	"shinycssloaders",
	"igraph",
	"visNetwork",
	"magick",
	"data.table",
	"markdown",
	"R.utils",
	"broom",
	"reshape",
	"fields",
	"swirl",
	"tibble",
	"webshot",
	"png",
	"car",
	"afex",
	"coin",
	"foreach",
	"doParallel",
	"perm",
	"V8",
	"digest",
	"vegan",
	"Rcpp",
	"openxlsx",
	"rcompanion"
	)

	install.packages(c("devtools","rmarkdown"))
	
	devtools::install_github("hadley/dplyr", build_vignettes  =  FALSE)

	devtools::install_github("rforge/rgl", subdir="pkg/rgl")

	for (i  in  1:length(packages)){

		pkgTest(packages[i])

	}




## Now you should have the following volumes in the same folder:
- **[optional file] dependencies.sh**
- **[file] packageInstaller.R:** The file we created in the last step
- **[folder] Libraries:** an emtpy folder where you intended to store installed pacakges
- **[folder] serverLog:** where all the errors and logs of the shiny-server would go to, this is really important if you want to figure out why things aren't working as intended, you can check the latest log files in this folder
- **[folder] App:** This folder should contain one of two setups: 
	1. A single file app with a file app.R inside it
	2. A double file app with a ui.R and server.R file inside it




## Now its finally time to make the Docker Compose File
	version: '3.6'
	services:
		rshiny_packages_dependencies:
		image:  'blackdoom/rshiny_packages_dependencies'
		container_name:  name_it_what_ever_you_want
		ports:
			- 3838:3838
		volumes:
			- ./dependencies.sh:/home/dependencies.sh
			- ./packageInstaller.R:/home/packageInstaller.R
			- ./Libraries:/home/RLibz/
			- ./serverLog:/var/log/
			- ./App:/srv/shiny-server/
		tty:  yes

	

