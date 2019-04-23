with import <nixpkgs> {};
let
    pyscrypt = python37.pkgs.buildPythonPackage rec {
      pname = "pyscrypt";
      version = "1.6.2";
      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "bafdd195f10f7c7395f0133bad09746a68e0e6b66da202c9bdb6b1eb4abba5e9";
      };
      doCheck = false;
      meta = with stdenv.lib; {
        homepage = "https://github.com/ricmoo/pyscrypt";
        license = licenses.mit;
        description = "Pure-Python Implementation of the scrypt password-based key derivation function and scrypt file format library";
      };
    };

    orderedmultidict = python37.pkgs.buildPythonPackage rec {
      pname = "orderedmultidict";
      version = "1.0";
      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "b89895ba6438038d0bdf88020ceff876cf3eae0d5c66a69b526fab31125db2c5";
      };
      checkInputs = [ python37Packages.pycodestyle ];
      propagatedBuildInputs = [ python37Packages.six ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gruns/orderedmultidict";
        license = licenses.unlicense;
        description = "Ordered Multivalue Dictionary - omdict.";
      };
    };

    furl = python37.pkgs.buildPythonPackage rec {
      pname = "furl";
      version = "2.0.0";
      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "fdcaedc1fb19a63d7d875b0105b0a5b496dd0989330d454a42bcb401fa5454ec";
      };
      checkInputs = [ python37Packages.flake8 ];
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
        checkInputs = [ python37Packages.pytest ];
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

    radicale = python37.pkgs.buildPythonPackage rec {
      pname = "Radicale";
      version = "2.1.11";
      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "02273fcc6ae10e0f74aa12652e24d0001eec8dbf467d54ddb4dfcc2af7d7a5db";
      };
      doCheck = false;
      checkInputs = [
        python37Packages.pytestrunner
        python37Packages.pytest-isort
        python37Packages.pytest-flake8
        python37Packages.pytestcov
      ];
      propagatedBuildInputs = [ python37Packages.dateutil python37Packages.vobject ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.radicale.org/";
        license = licenses.gpl1;
        description = "CalDAV and CardDAV Server";
      };
    };

    radicale-storage-etesync = python37.pkgs.buildPythonPackage rec {
      pname = "radicale_storage_etesync";
      version = "0.7.0";
      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "1vq889jshlb3m13m2lgbjy440lph27ig53sfipkj7ds5sb5znhh5";
      };
      propagatedBuildInputs = [ etesync radicale pyscrypt orderedmultidict furl
        python37Packages.coverage
        python37Packages.pyasn1
        python37Packages.appdirs
        python37Packages.vobject
        python37Packages.py
        python37Packages.cffi
        python37Packages.pyparsing
        python37Packages.requests
        python37Packages.peewee
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/etesync/radicale_storage_etesync";
        license = licenses.gpl3;
        description = "An EteSync storage plugin for radicale";
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
      radicale
      furl
      orderedmultidict
      pyscrypt
      etesync
      radicale-storage-etesync
      ];
}
