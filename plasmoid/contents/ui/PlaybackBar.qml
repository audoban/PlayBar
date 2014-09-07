// -*- coding: iso-8859-1 -*-
/*
 *   Author: audoban <audoban@openmailbox.org>
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
import org.kde.plasma.components 0.1

PlaybackItem{
    id: playbackbar

	property bool vertical: false

	property bool flatButtons: plasmoid.readConfig('flatButtons')

	width: childrenRect.width

    height: childrenRect.height

	Component.onCompleted: {

        function formFactorChanged()
        {
            switch(plasmoid.formFactor)
            {
                case Planar:
                case MediaCenter:
                case Horizontal:
                    vertical = false
                    return
                case Vertical:
                    vertical = true
                    return
            }
        }
        formFactorChanged()
        plasmoid.formFactorChanged.connect(formFactorChanged)

		function connectMediaActions(){
			model.itemAt(0).clicked.connect(previous)
			model.itemAt(1).clicked.connect(playPause)
			model.itemAt(2).clicked.connect(stop)
			model.itemAt(3).clicked.connect(next)
		}

		connectMediaActions()

		plasmoid.addEventListener('configChanged', function(){
				if(plasmoid.readConfig('flatButtons') != flatButtons){
					flatButtons = !flatButtons
					connectMediaActions()
				}
				if(playing) buttons.playingState()
				else buttons.pausedState()
			}
		)
    }

	ListModel{
        id: playmodel
        ListElement{
            icon: "media-skip-backward"
        }
        ListElement{
            icon: "media-playback-start"
        }
        ListElement{
            icon: "media-playback-stop"
        }
        ListElement{
            icon: "media-skip-forward"
        }

    }

    Component{
        id: toolButtonDelegate

        ToolButton{
            iconSource: icon
            visible: index == 2 ? showStop : true
			width: buttonSize + 2
			height: buttonSize + 2
        }
    }

    Component{
        id: iconWidgetDelegate

        IconWidget{
			svg: update()
            iconSource: icon
            visible: index == 2 ? showStop : true
			size: buttonSize

			function update(){
				if(plasmoid.readConfig("opaqueIcons") == true)
					return Svg(plasmoid.readConfig("media-opaque-bar"))
				else return Svg(plasmoid.readConfig("media-clear-bar"))
			}

			Component.onCompleted:{
				plasmoid.addEventListener('configChanged', function(){
					svg = update(); svgChanged(); elementIdChanged();
				})
			}
        }
    }

    Flow {
        id: buttons

        spacing: flatButtons ? 5 : -1
		flow: vertical ? Flow.TopToBottom : Flow.LeftToRight

		function playingState(){
			model.itemAt(1).iconSource = "media-playback-pause"
		}

		function pausedState(){
			model.itemAt(1).iconSource = "media-playback-start"
		}

		states:[
			State{
				name: "Playing"
				when: playing
				StateChangeScript{
					script: buttons.playingState()
				}
			},
			State{
				name: "Paused"
				when: !playing
				StateChangeScript{
					script: buttons.pausedState()
				}
			}
		]

        move: Transition {
            NumberAnimation {
                property: "y"
                easing.type: Easing.Linear
            }
        }

        Repeater{
            id: model
            model: playmodel
            delegate: flatButtons ? iconWidgetDelegate : toolButtonDelegate
        }
    }
}
