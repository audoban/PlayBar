// -*- coding: iso-8859-1 -*-
/*
 *   Author: audoban <audoban@openmailbox.org>
 *   Date: jue may 1 2014, 13:05:43
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 1.1
import org.kde.plasma.core 0.1


SvgItem {
	id: iconWidget

	property alias iconSource: iconWidget.elementId

	property int size: theme.smallIconSize + 3

	implicitWidth: size

	implicitHeight: size

	smooth: true

	signal clicked()

	Component.onCompleted: mouseArea.clicked.connect(clicked)

	SequentialAnimation on scale{
		id: animA
		running: false
		alwaysRunToEnd: true
		NumberAnimation { to: 0.9; duration: 150 }
	}
	SequentialAnimation on scale{
		id: animB
		running: scale == 0.9 && !mouseArea.pressed
		alwaysRunToEnd: true
		NumberAnimation { to: 1; duration: 150 }
	}

	MouseArea{
		id: mouseArea
		anchors.fill: parent

		onPressed:  animA.start()
	}
}
