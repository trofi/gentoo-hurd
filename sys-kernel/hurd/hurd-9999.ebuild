# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3 toolchain-funcs

DESCRIPTION="GNU hurd kernel based on GNU Mach"
HOMEPAGE="https://www.gnu.org/software/hurd/hurd.html"
#SRC_URI="ftp://ftp.gnu.org/gnu/hurd/hurd-${PV}.tar.gz"
EGIT_REPO_URI="https://git.savannah.gnu.org/git/hurd/hurd.git"
SLOT="0"
KEYWORDS=""
LICENSE="GPL-2+"
IUSE="headers-only"

CHOST=${CATEGORY#cross-}
CTARGET=${CATEGORY#cross-}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local conf_args=(
		--prefix="${EPREFIX}"/usr/${CTARGET}/usr
	)
	if use headers-only; then
		conf_args+=(
			# We don't have a cross-compiler
			# with proper --sysroot yet.
			# Pass in correct include path
			CPPFLAGS="${CPPFLAGS} -I${EPREFIX}/usr/${CTARGET}/usr/include"
			# And host compiler in case we have broken cross-compiler
			CC=$(tc-getBUILD_CC)
		)
	fi
	econf "${conf_args[@]}"
}

src_compile() {
	use headers-only && return
}

src_test() {
	use headers-only && return
}

src_install() {
	if use headers-only; then
		emake DESTDIR="${D}" install-headers
	else
		default
	fi
}
