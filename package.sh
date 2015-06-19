#!/bin/bash
#
# This script will create a snapshot of the working directory (including
# checked out modules) and place it in pkg/. The resulting artifact can be
# uploaded to a file hosting service and fetched on target nodes.

r10k puppetfile install -v

working_dir=$(basename $(cd $(dirname $0) && pwd))
containing_dir=$(cd $(dirname $0)/.. && pwd)
basename="${containing_dir}/${working_dir}"
echo $working_dir
echo $containing_dir
echo $basename
version=$1
versioned_name="seteam-production-${version}"
mkdir -p "${basename}/pkg"

# Because engineer laptops run OSX and build systems run Linux, this script
# should work correctly on both. Because BSD tar accepts different flags from
# GNU tar for some of the more complex operations, we need to define logic to
# enable that.
if [[ "$(uname)" = 'Darwin' ]]; then
  platform_tar_flags="-s '/${working_dir}/${versioned_name}/' --disable-copyfile"
else
  platform_tar_flags="--transform='s/${working_dir}/${versioned_name}/'"
fi

tar \
  $platform_tar_flags \
  -C "${containing_dir}" \
  --exclude ".git" \
  --exclude ".gitignore" \
  --exclude "${working_dir}/.librarian" \
  --exclude "${working_dir}/.tmp" \
  --exclude "${working_dir}/.gitignore" \
  --exclude "${working_dir}/pkg" \
  --exclude "${working_dir}/pkg/*" \
  --exclude "${working_dir}/package.sh" \
  -cvzf "${containing_dir}/${versioned_name}.tar.gz" \
  "${working_dir}"
mv "${containing_dir}/${versioned_name}.tar.gz" "${basename}/pkg"
