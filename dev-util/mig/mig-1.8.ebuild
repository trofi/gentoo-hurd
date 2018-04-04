# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="GNU interface generator for Mach 3.0 microkernel"
HOMEPAGE="https://www.gnu.org/software/hurd/microkernel/mach/mig/gnu_mig.html"
SRC_URI="ftp://ftp.gnu.org/gnu/mig/mig-${PV}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2+"
IUSE="headers-only"

PATCHES=("${FILESDIR}"/${P}-cross.patch)

CTARGET=${CATEGORY#cross-}

src_prepare() {
	default
	eautoconf
}

src_configure() {
	local conf_args=()
	if use headers-only; then
		# we don't have any cross-compiler yet:
		# use host compiler with augmented header paths
		conf_args+=(
			TARGET_CC=${CHOST}-gcc
			ac_cv_prog_TARGET_CC=${CHOST}-gcc
			# TODO: is --sysroot better here to avoid host enviroment leak in?
			TARGET_CPPFLAGS="-I${EPREFIX}/usr/${CTARGET}/usr/include"
		)
	fi
	econf "${conf_args[@]}"
}

src_test() {
	# Compiler is not exactly for target
	use headers-only && return
	default
}
