# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit java-pkg-2 java-ant-2 python-r1

# [ "$PV" == "9999" ] && inherit subversion
inherit subversion

DESCRIPTION="Viewer of next generation sequence assemblies and alignments"
HOMEPAGE="http://bioinf.scri.ac.uk/tablet/"
if [ "$PV" == "9999" ]; then
	ESVN_REPO_URI="http://ics.hutton.ac.uk/svn/tablet/trunk/"
	KEYWORDS=""
else
	ESVN_REPO_URI="http://ics.hutton.ac.uk/svn/tablet/tags/${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Tablet"
SLOT="0"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=virtual/jdk-1.8:*"
RDEPEND="${PYTHON_DEPS}
	>=virtual/jre-1.8:*
	sci-biology/samtools
	sci-biology/picard
	dev-db/sqlite:3"

S="${WORKDIR}"

src_install() {
	cd lib || die
	java-pkg_dojar tablet.jar
	java-pkg_dolauncher ${PN}
	java-pkg_dojar tablet-resources.jar
	java-pkg_dojar flamingo.jar
	java-pkg_dojar scri-commons.jar
	java-pkg_dojar samtools*.jar

	echo "PATH=${EPREFIX}/usr/share/${PN}/" > 99Tablet
	doenvd 99Tablet
}