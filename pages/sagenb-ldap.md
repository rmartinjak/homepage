Installing sage and sagenb with LDAP support from scratch
---------------------------------------------------------

1. Download and extract/build sage (binary package on Ubuntu or source package elsewhere):

		wget http://sage.mirror.garr.it/mirrors/sage/linux/64bit/sage-5.5-linux-64bit-ubuntu_12.04.1_lts-x86_64-Linux.tar.lzma
		tar xf sage-*.tar.lzma
		mv sage-5.5-linux-64bit-ubuntu_12.04.1_lts-x86_64-Linux sage-5.5
		export SAGE_ROOT=~/sage-5.5

1. Install openssl. This will take a long time, especially the third step:

		$SAGE_ROOT/sage -i openssl
		$SAGE_ROOT/sage -f python
		SAGE_UPGRADING=yes make ssl

1. Install the required development packages:

	For example (Debian or Ubuntu):

		sudo apt-get install libldap2-dev libsasl2-dev

1. Install python-ldap:

		$SAGE_ROOT/sage -sh
		(sage-sh) easy_install python-ldap


1. Clone the official `sagenb` git repo:

		cd $SAGE_ROOT/devel
		git clone https://github.com/sagemath/sagenb.git sagenb-flask
		rm sagenb
		ln -s sagenb sagenb-flask
		cd sagenb

1. Add and use the `ldap` branch of `rmartinjak/sagenb.git`

	No longer needed, ldap authentication has been merged to the official repo :)
	
1. Run `setup.py develop`

		$SAGE_ROOT/sage -python setup.py develop

1. Start the notebook:
		
		$SAGE_ROOT/sage -n secure=True automatic_login=False


To configure LDAP, log into the notebook as admin and go to
`Settings` -> `Notebook Settings`
