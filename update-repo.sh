#!/bin/sh

REPO_NAME="mcgrew"
REPO_DIR="/var/www/html/archlinux/$REPO_NAME/os"
ARCH="i686 x86_64"

# nicenesses range from -20 (most favorable scheduling) to 19 (least favorable)
NICE=19

# 0 for none, 1 for real time, 2 for best-effort, 3 for idle
IONICE_CLASS=3

# 0-7 (for IONICE_CLASS 1 and 2 only), 0=highest, 7=lowest
IONICE_PRIORITY=7


DB_FILE="${REPO_NAME}.db"
for arch in $ARCH; do 
	echo "Updating $arch"
	UPDATE_REPO="/usr/bin/repo-add ${REPO_DIR}/$arch/${DB_FILE}.tar.gz ${REPO_DIR}/$arch/*.pkg.tar.*"

	if [ -x /usr/bin/nice ]; then
  UPDATE_REPO="/usr/bin/nice -n ${NICE:-19} ${UPDATE_REPO}"
	fi

	if [ -x /usr/bin/ionice ]; then
  UPDATE_REPO="/usr/bin/ionice -c ${IONICE_CLASS:-2} -n ${IONICE_PRIORITY:-7} ${UPDATE_REPO}"
	fi

	if [ ! -z "$REPO_DIR" ]; then
		cd "$REPO_DIR/$arch"
	newest="$(ls -1c | head -1)"
	# Update the repo database if it is not the newest file
	if [ ! -z "${DB_FILE}" ]; then
		if [ "${newest:0:${#DB_FILE}}" != "${DB_FILE}" ]; then
				rm -f ${DB_FILE}*
				${UPDATE_REPO}
		else
				echo "Repo database for $arch already up to date."
		fi;
	else
		echo "Configuration error dectected in $0";
	fi;
fi;
done;

