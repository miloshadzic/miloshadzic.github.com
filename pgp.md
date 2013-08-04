---
layout: centered
title: PGP
---

<br />

PGP
-------

My PGP key is [4A8BEBB8][pgp_key]. You can import it with:

~~~
$ wget https://raw.github.com/miloshadzic/miloshadzic.github.com/master/miloshadzic.asc
$ gpg --import miloshadzic.asc
gpg: key 4A8BEBB8: "Miloš Hadžić <milos@rightfold.io>" imported
gpg: Total number processed: 1
gpg:               imported: 1
~~~

Verify the fingerprint:

~~~
$ gpg --fingerprint 0x4A8BEBB8
pub   4096R/4A8BEBB8 2013-02-03
      Key fingerprint = 7AC3 06DD B8DF C7CB A6BC  5D37 7859 25EB 4A8B EBB8
uid                  Miloš Hadžić <milos@rightfold.io>
uid                  Miloš Hadžić <milos.hadzic@gmail.com>
sub   4096R/F5463149 2013-02-03
~~~

[pgp_key]: http://pgp.mit.edu:11371/pks/lookup?op=get&search=0x785925EB4A8BEBB8
