# There are now just centos 7 variants
old_vendor="-conda_cos7-linux-gnu-"

for exe in `ls ${PREFIX}/bin/*-conda-linux-gnu-*`; do
  nm=`basename ${exe}`
  new_nm=${nm/"-conda-linux-gnu-"/${old_vendor}}
  if [ ! -f ${PREFIX}/bin/${new_nm} ]; then
    ln -s ${exe} ${PREFIX}/bin/${new_nm}
  fi
done
