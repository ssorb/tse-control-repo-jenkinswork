#!/bin/bash
#
# This script will create a snapshot of the working directory (including
# checked out modules) and place it in pkg/. The resulting artifact can be
# uploaded to a file hosting service and fetched on target nodes.

r10k puppetfile install

working_dir=$(basename $(cd $(dirname $0) && pwd))
containing_dir=$(cd $(dirname $0)/.. && pwd)
basename="${containing_dir}/${working_dir}"
version=$1
versioned_name="seteam-production-${version}"
mkdir -p "${basename}/pkg"
tar \
  --disable-copyfile \
  -C "${containing_dir}" \
  --exclude ".git" \
  --exclude ".gitignore" \
  --exclude "${working_dir}/.librarian" \
  --exclude "${working_dir}/.tmp" \
  --exclude "${working_dir}/.gitignore" \
  --exclude "${working_dir}/pkg" \
  --exclude "${working_dir}/pkg/*" \
  --exclude "${working_dir}/package.sh" \
  -s "/${working_dir}/${versioned_name}/" \
  -cvzf "${containing_dir}/${versioned_name}.tar.gz" \
  "${working_dir}"
mv "${containing_dir}/${versioned_name}.tar.gz" "${basename}/pkg"
