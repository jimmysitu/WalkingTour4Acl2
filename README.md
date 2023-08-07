

# Jimmy's Playground of  Learning ACL2

This repo is used as Jimmy's playground of learning **ACL2**. It covers

* [A walking tour of ACL2](https://www.cs.utexas.edu/users/moore/acl2/v8-5/combined-manual/index.html?topic=ACL2____A_02Walking_02Tour_02of_02ACL2),  about 1h

* [Introduction-to-the-theorem-prover](https://www.cs.utexas.edu/users/moore/acl2/v8-5/combined-manual/index.html?topic=ACL2____INTRODUCTION-TO-THE-THEOREM-PROVER), about 40h

* [Computer-Aided Reasoning: An Approach](https://www.cs.utexas.edu/users/moore/publications/acl2-books/car/index.html)

  

## Setup Environment

### Eclipse Approach

#### Out of Box Install

Download the zip [here](http://acl2s.ccs.neu.edu/acl2s/doc/download.html), and unpack and go...

#### More Complicate Way

Install acl2s with Eclipse, following instruction [here](http://acl2s.ccs.neu.edu/acl2s/doc/installation.html#install-old)

For Ubuntu, install *default-jre* and *Eclipse*

```bash
sudo apt install default-jre
sudo snap install eclipse --classic
```

https://www.cs.utexas.edu/users/moore/publications/acl2-books/car/index.htmlInstall ACL2s with the Eclipse Updater

* Help | Install New Software..

* Click the "Add..." button near top right and enter Name: `ACL2 Sedan` and enter Location:

  >  http://acl2s.ccs.neu.edu/acl2s/update

* This should reveal an "ACL2 Images" and an "ACL2s Components" category.

* Under "ACL2s Components," be sure to select "ACL2s"  

* Under "ACL2 Image", be sure to select "ACL2 Image (Linux/x86_64)"

* Read and accept the license agreement and click "Next" and/or "Finish" until it's installed.

* Restart Eclipse as recommended.

However, installing ACL2 Image from update site, changes the date of book files.  It may cause certify book fail. Download the tar.gz file form website and override it. Be careful, do not change the date of book files here, usually  `mv` or `cp -p`command is enough.

```bash
wget http://acl2s.ccs.neu.edu/acl2s/src/acl2/acl2-image-8.0-linux.x86_64.tar.gz
tar -zxf acl2-image-8.0-linux.x86_64.tar.gz
rm -rf $ECLIPSE_PLUGINS_PATH/plugins/acl2_image.linux.x86_64_8.0.0 
mv acl2-image-8.0-linux.x86_64 $ECLIPSE_PLUGINS_PATH/plugins/acl2_image.linux.x86_64_8.0.0
```

Vim user may like to install Vrapper plugin for Eclipse.

#### Shortcuts

| Action                |     Shortcut Key     | Comment                |
| --------------------- | :------------------: | ---------------------- |
| Advance Todo          |   Shift + Ctrl + I   | Move on one command    |
| Move line past Cursor | Shift + Ctrl + Enter | Move to current cursor |
| Retreat line          |   Shift + Ctrl + M   | Undo last command      |



### Emacs Approach

#### Out of Box Install

Install Emacs and acl2 directly. For Ubuntu users, it may need 2GB+ hard disk space. This ACL2 is compiled with GCL, which is good enough for simple demo.

```bash
sudo apt install acl2
```

#### Install for Experts

Since quicklisp books have not yet been made to work with GCL, most ACL2 users use CCL or SBCL.

##### Install Clozure CL (CCL)

Do a fresh clone for the first, switch to latest release.

```bash
sudo git clone https://github.com/Clozure/ccl.git /opt/ccl
sudo git checkout v1.12.1
```

Go to check  [here](https://github.com/Clozure/ccl/releases/) to check lastest release, download and unpacking the bootstrapping binaries, you can rebuild CCL by evaluating `(rebuild-ccl :full t)` as usual.

```bash
curl -L -O https://github.com/Clozure/ccl/releases/download/v1.12.1/linuxx86.tar.gz
tar -zxf linuxx86.tar.gz
```

Rebuild and quit, twice

```
echo '(rebuild-ccl :full t)' | sudo ./lx86cl64
echo '(rebuild-ccl :full t)' | sudo ./lx86cl64
```

Copy the executable script to $PATH, e.g. /usr/local/bin

```bash
sudo script/ccl64 /usr/local/bin/ccl
```

Change the $CCL_DEFAULT_DIRECTORY to /opt/ccl

```bash
if [ -z "$CCL_DEFAULT_DIRECTORY" ]; then
  CCL_DEFAULT_DIRECTORY=/opt/ccl
fi
```

##### Install ACL2

Compile ACL2 with CCL

```bash
sudo git clone https://github.com/acl2/acl2.git
sudo git checkout 8.5

```

Rebuild CCL with new memory settings, which Centaur recommands,

```bash
cd /opt/ccl
sudo ./lx86cl64 -n < /opt/acl2/books/centaur/ccl-config.lsp
cd /opt/acl2
sudo make LISP=ccl
```





Certify some books, for example with

```bash
make basic
```



## Walking Tour

Follow the tour instruction. `walkingTour.lisp` is includes the code of `app` example in the tour.

## Introduction to the Theorem Prover

Most code in the tutorial is intended to run, so there is no `.lisp` relative to this tour.

## Computer-Aide Reasoning: An Approach (CAR)

Solutions to exercises are [here](https://github.com/acl2/acl2/tree/master/books/textbook)

### Tips

* When the proof of theorem stop at a subgoal, try to understand what is this subgoal want to assert.

  * One common case is that subgoal needs too much propositions which it is not necessary. Try to proof a theorem stronger theorem with less proposition
  * Some cases, one proposition can be implied by other propositions
  *  Other common case is that subgoal is a false proposition, which can never be proof. In such case, there are usually contradiction in propositions. Try to write out a theorem to assert this contradiction

* When the proof of theorem cannot be stopped in a while, usually more than several minutes, the proof maybe come into a dead loop, try this command to check the root cause

  ```lisp
  :brr t
  (cw-gstack :frames 30)
  ```

* Some helper of aux theory may let the goal fall into a rewrite dead loop. Try to disable some helper s,  so the proof tree can go back to the same subgoal

   

## Computer-Aide Reasoning: ACL2 Case Studies (ACS)



