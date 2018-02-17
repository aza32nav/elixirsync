# ElixiRsync Project

Automation backups with rsync using a file with selected folders

## Warning << This is a personal project >> Warning

+ This is a first commit
+ It is still in development and need a lot of improves
+ Include type especifications (@spec)
+ Include tests

The program works but check the code for understanding its operation
and avoid errors in the backup.

The file structure is:

```
/home/user/
/run/media/user/externalStorage/
Documents/
Music/
Videos/
```

1. The first line is the origin folder
2. The second line is the destination folder
3. The next lines are the folders to be backed up

for example, this would be the first command generated:
```
rsync -rtvu --delete /home/user/Documents/ /run/media/user/externalStorage/Documents/
```

__Don't forget to put the / at the end of the folder lines and start the folder 
names to be backed up without / to avoid rsync duplication problems.__

## License

This source code is released under MIT License.
