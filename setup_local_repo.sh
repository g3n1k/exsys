read -p 'path: ' repo_path

fr="rhel7-local.repo"

touch "$fr"
echo "[RepoLocal]" >> "$fr"
echo "name=baseurl" >> "$fr"
echo "baseurl=file://$repo_path" >> "$fr"
echo "enable=1" >> "$fr"
echo "gpgcheck=0" >> "$fr"

mv $fr /etc/yum.repos.d/
yum clean all && yum makecache

