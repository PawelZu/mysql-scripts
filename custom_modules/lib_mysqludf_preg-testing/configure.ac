AC_PREREQ(2.59)

AC_INIT(lib_mysqludf_preg,1.2-rc2,raw@goodhumans.net)

AC_CONFIG_AUX_DIR(config)

m4_include([config/ax_lib_mysql.m4])
m4_include([config/ax_mysql_bin.m4])
m4_include([config/pcre.m4])
m4_include([config/ghmysql.m4])
m4_include([config/ax_pthread.m4])
m4_include([config/ax_pthread_np.m4])

AM_INIT_AUTOMAKE

AC_LIBTOOL_WIN32_DLL
AM_PROG_LIBTOOL
AC_PROG_CC

AX_MYSQL_BIN

AX_LIB_MYSQL(,,AC_MSG_ERROR("Can't find mysql library" ) )
if test -n "$MYSQL_PLUGINDIR" && test "$libdir" == '${exec_prefix}/lib' ; then
  AC_MSG_NOTICE(setting libdir to mysql plugin dir $MYSQL_PLUGINDIR)
  libdir=$MYSQL_PLUGINDIR
  AC_SUBST(libdir)
fi

AM_PATH_PCRE(1,,AC_MSG_ERROR( "Can't find libpcre" ) )

AX_PTHREAD(,AC_MSG_ERROR( "Can't find libpthread" ) )
AX_PTHREAD_NP(,AC_MSG_ERROR( "Can't find libpthread" ) )

AX_GHMYSQL

AC_CONFIG_HEADERS(config.h)

AC_OUTPUT([ Makefile
test/Makefile
doc/Makefile
])
