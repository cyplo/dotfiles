with import <nixpkgs> {};
let
    pyscrypt = python37.pkgs.buildPythonPackage {
      name = "pyscrypt-1.6.2";
      src = fetchurl {
         url = "https://files.pythonhosted.org/packages/c6/56/51603b5714d221b784e4cbc2790b1215b3fb108e4d308a0bd52e4c3ce532/pyscrypt-1.6.2.tar.gz";
         sha256 = "bafdd195f10f7c7395f0133bad09746a68e0e6b66da202c9bdb6b1eb4abba5e9"; };
      doCheck = false;
      meta = with stdenv.lib; {
        homepage = "https://github.com/ricmoo/pyscrypt";
        license = licenses.mit;
        description = "Pure-Python Implementation of the scrypt password-based key derivation function and scrypt file format library";
      };
    };
    orderedmultidict = python37.pkgs.buildPythonPackage {
      name = "orderedmultidict-1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/19/67/2e1462785b84f40812e61d349f77063939f8f220345b0dfc26c4e3e07af0/orderedmultidict-1.0.tar.gz";
        sha256 = "b89895ba6438038d0bdf88020ceff876cf3eae0d5c66a69b526fab31125db2c5"; };
      doCheck = false;
      propagatedBuildInputs = [ python37Packages.six ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gruns/orderedmultidict";
        license = "License :: Freely Distributable";
        description = "Ordered Multivalue Dictionary - omdict.";
      };
    };
    furl = python37.pkgs.buildPythonPackage {
      name = "furl-2.0.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/93/70/e266a29c3c1c9ec94d7fcb3232e0d77bfa04c281f44a9edeb9946a256d91/furl-2.0.0.tar.gz";
        sha256 = "fdcaedc1fb19a63d7d875b0105b0a5b496dd0989330d454a42bcb401fa5454ec"; };
      doCheck = false;
      propagatedBuildInputs = [ orderedmultidict python37Packages.six ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gruns/furl";
        license = licenses.publicDomain;
        description = "URL manipulation made simple.";
      };
    };
    etesync = python37.pkgs.buildPythonPackage rec {
        pname = "etesync";
        version = "0.8.1";
        src = pythonPackages.fetchPypi {
          inherit pname version;
          sha256 = "007zsdn0zv0f80wpyf8fzl446wmv7jr8a0pdp4wj1y61b14f4q0p";
        };
        doCheck = false;
        meta = with pkgs.stdenv.lib; {
          homepage = "https://github.com/etesync/pyetesync";
          license = licenses.lgpl3;
          description = "Python client library for EteSync";
        };
        propagatedBuildInputs = [
          python37Packages.appdirs
          python37Packages.asn1crypto
          python37Packages.certifi
          python37Packages.cffi
          python37Packages.chardet
          python37Packages.coverage
          python37Packages.cryptography
          python37Packages.idna
          python37Packages.packaging
          python37Packages.peewee
          python37Packages.py
          python37Packages.pyasn1
          python37Packages.pycparser
          python37Packages.pyparsing
          python37Packages.python-dateutil
          python37Packages.requests
          python37Packages.six
          python37Packages.urllib3
          python37Packages.vobject
          pyscrypt
          orderedmultidict
          furl
          ];
    };

    Radicale = python37.pkgs.buildPythonPackage rec {
      name = "Radicale-2.1.11";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/be/50/b5094950d53f11e56eb17932469e0e313275da0c5e633590c939863f3c37/Radicale-2.1.11.tar.gz";
        sha256 = "02273fcc6ae10e0f74aa12652e24d0001eec8dbf467d54ddb4dfcc2af7d7a5db";
      };
      doCheck = false;
      propagatedBuildInputs = [ python37Packages.dateutil python37Packages.vobject ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.radicale.org/";
        license = licenses.gpl1;
        description = "CalDAV and CardDAV Server";
      };
    };

    radicale-storage-etesync = python37.pkgs.buildPythonPackage rec {
      name = "radicale-storage-etesync-0.7.0";
      src = pkgs.fetchurl {
         url = "https://files.pythonhosted.org/packages/55/77/c9f3f9a86e2e31204cb5f0f1fbf24745ac86f8c739618db41e52390c73c2/radicale_storage_etesync-0.7.0.tar.gz";
         sha256 = "0542fbcbd245b723e78d4e8ff2e211f052408897eb515147a86351a8654208ef";
      };
      doCheck = false;
      propagatedBuildInputs = [ etesync Radicale pyscrypt orderedmultidict furl
        python37Packages.coverage python37Packages.pyasn1 python37Packages.appdirs
        python37Packages.vobject python37Packages.py python37Packages.cffi
        python37Packages.pyparsing python37Packages.requests python37Packages.peewee
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/etesync/radicale_storage_etesync";
        license = "GPL";
        description = "An EteSync storage plugin for Radicale";
      };
    };

in

python37.pkgs.buildPythonPackage rec {
    pname = "etesync-dav";
    version = "0.5.0";
    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "18ykgi3gqy6p7wj7n9d88rsn0y566ypl5ixpb3v7l3f6w5fffwh1";
    };
    propagatedBuildInputs = [
      python37Packages.pytz python37Packages.pytzdata python37Packages.appdirs
      python37Packages.appdirs
      python37Packages.asn1crypto
      python37Packages.certifi
      python37Packages.cffi
      python37Packages.chardet
      python37Packages.coverage
      python37Packages.cryptography
      python37Packages.idna
      python37Packages.packaging
      python37Packages.peewee
      python37Packages.py
      python37Packages.pyasn1
      python37Packages.pycparser
      python37Packages.pyparsing
      python37Packages.python-dateutil
      python37Packages.requests
      python37Packages.six
      python37Packages.urllib3
      python37Packages.vobject
      Radicale
      furl
      orderedmultidict
      pyscrypt
      etesync
      radicale-storage-etesync
      ];
}
