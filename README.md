This repo is intended to provide a quick, easy virtual environment to develop the SCOOP Query Engine and SCOOP Visualizer.

### Getting Started:

```bash
git clone https://github.com/Hoverbear/scoop-devops-vm.git --recursive
cd scoop-devops-vm
vagrant up # First start will take awhile.
```

If you want the latest and buggiest, switch the submodules to `master` branches before running `vagrant up`.
```bash
cd $MODULE
git checkout master
```

### Visiting
Visit [https://127.0.0.1:8081](https://127.0.0.1:8081) for the visualizer.

Visit [https://localhost:8080](https://localhost:8080) for the query engine.

*Note these URLs are chosen for a reason, using `localhost` for both will result in cookie issues, really.*

There is a pre-populated user on the query engine with username `test` and password `test`. The visualizer is already preset to be a consumer for the queryengine.


### Updating a Module
```bash
cd $MODULE
git branch # Note how you're on a detached head.
git checkout master # Important: Change to master

# Make edits

git commit -a -m "My Changes"
git push
cd .. # Back to project root
git commit -a -m "Bumped $MODULE"
```

Any changes to a module should result in the service being restarted within a few seconds. You can check via `docker logs -f $MODULE` and looking for a `crashing child` output.

### Updating the Database templates
Make sure you have a locally running copy of Mongo, or get clever and modify the running mongodb VMs and dump them.
**Your own local copy:**
```bash
cd db-data/$MODULE
mongorestore -d $MODULE

# Make edits via `mongo` or whatever you want.

rm -r dump # Remove the existing dump.
mongodump -d $MODULE
```

### Re-provisioning
Sometimes it is necessary to re-provision the VM. This should be done in the following cases:

* The database templates have been edited.
* Things have irrevocably stopped working.
* `Dockerfile`s have been edited
* The `Vagrantfile` has been edited (You might want to `destroy` for this)

To safely re-provision:
```bash
vagrant ssh # Now inside the VM.
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi visualizer queryengine
```

Then, on the host machine:
```bash
vagrant provision
```

### Tailing the Logs
To tail the logs of any node of the cluster, inside of the vagrant VM issue:
```bash
docker logs -f $MODULE
```
