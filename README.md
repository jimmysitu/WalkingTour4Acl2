# Walking Tour  for ACL2
This repo is used as Jimmy's playground of learning ACL2. It covers

* [A walking tour of ACL2](https://www.cs.utexas.edu/users/moore/acl2/v8-5/combined-manual/index.html?topic=ACL2____A_02Walking_02Tour_02of_02ACL2),  about 1h

* [Introduction-to-the-theorem-prover](https://www.cs.utexas.edu/users/moore/acl2/v8-5/combined-manual/index.html?topic=ACL2____INTRODUCTION-TO-THE-THEOREM-PROVER), about 40h



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

Install ACL2s with the Eclipse Updater

* Help | Install New Software..

* Click the "Add..." button near top right and enter Name: ACL2 Sedan and enter Location:

  >  http://acl2s.ccs.neu.edu/acl2s/update

* This should reveal an "ACL2 Images" and an "ACL2s Components" category.

* Under "ACL2s Components," be sure to select "ACL2s"  

* Under "ACL2 Image", be sure to select "ACL2 Image (Linux/x86_64)"

* Read and accept the license agreement and click "Next" and/or "Finish" until it's installed.

* Restart Eclipse as recommended.

However, installing ACL2 Image from update site, changes the date of book files.  It may cause certify book fail. Download the tar.gz file form website and override it.

```bash
wget http://acl2s.ccs.neu.edu/acl2s/src/acl2/acl2-image-8.0-linux.x86_64.tar.gz
tar -zxf acl2-image-8.0-linux.x86_64.tar.gz
rm -rf ~/.eclipse/360744286_linux_gtk_x86_64/plugins/acl2_image.linux.x86_64_8.0.0 
mv acl2-image-8.0-linux.x86_64 ~/.eclipse/360744286_linux_gtk_x86_64/plugins/acl2_image.linux.x86_64_8.0.0
```

Vim user may like to install Vrapper plugin for Eclipse.

#### Shortcuts

| Action                |     Shortcut Key     | Comment                |
| --------------------- | :------------------: | ---------------------- |
| Advance Todo          |   Shift + Ctrl + I   | Move on one command    |
| Move line past Cursor | Shift + Ctrl + Enter | Move to current cursor |
| Retreat line          |   Shift + Ctrl + M   | Undo last command      |



### Emacs Approach

Install Emacs and acl2 directly. For ubuntu users, it may need 2GB+ hard disk space

```bash
sudo apt install acl2
```

## Walking Tour

