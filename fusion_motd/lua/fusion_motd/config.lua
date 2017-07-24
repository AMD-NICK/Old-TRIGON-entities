-- __  ____  ___   _____ __            ___
-- \ \/ /  |/  /  / ___// /___  ______/ (_)___
--  \  / /|_/ /   \__ \/ __/ / / / __  / / __ \
--  / / /  / /   ___/ / /_/ /_/ / /_/ / / /_/ /
-- /_/_/  /_/   /____/\__/\__,_/\__,_/_/\____/

MOTD.Cfg = {}
local motd = MOTD.Cfg
-- Don't touch lines above

-- If the MOTD is enabled. If false then motd shouldn't be shown on
motd.enabled     = true

-- Should the MOTD show when a player joins
motd.OpenOnJoin  = true

-- Chat commands to open the MOTD
motd.cmds        = {
	["/info"] = true,
	["/motd"] = true,
}

-- Animation speed in seconds. The biggest value - the lower speed
motd.aspeed      = 1

-- Size of the frame in pixels
-- I do not know how to explain, so just experiment
motd.frameSize   = CLIENT and ScrW() >= 1366 and 30 or 15 -- if screen width > or equal to 1366 then frameSize = 30. Else = 15

-- Buttons shown right of the motd
/************************************************************************************

	{
		NAME = "Google",
		URL = "https://google.com",
		ICO = "materials/vgui/ym-studios/icons/magnifier.png",
		SVFUNC = function(ply, slf) end,
		CLFUNC = function(slf) end,
	},

************************************************************************************/

motd.Buttons = {
	{
		NAME = "vk.com/trigonim", -- First button MUST be a link. NOT function or smthnk else
		URL = "https://vk.com/wall-95087107?own=1&_fm=group",
		ICO = "materials/vgui/icons/fa32/vimeo-square.png",
	},
	-- {
	-- 	NAME = "Ченджлог",
	-- 	URL = "http://trigon.im/index.php?threads/changelog.43/#post-58",
	-- 	ICO = "materials/vgui/ym-studios/icons/todo_note.png",
	-- },
	{
		NAME = "Форум",
		URL = "https://trigon.im",
		ICO = "materials/vgui/icons/fa32/comments.png",
	},
	-- {
	-- 	NAME = "Quick register",
	-- 	URL = "https://trigon.im/index.php?register/steam&reg=1",
	-- 	CLFUNC = function(slf)
	-- 		Derma_Query("Откроется меню, через которое вы реально в 2 клика сможете зарегистрироваться на форуме и оставлять жалобы на игроков или предлагать свои идеи",
	-- 			"Быстрая регистрация",
	-- 			"Сделаем же это!",
	-- 			function() ui.OpenURL(slf.URL) end,
	-- 			"Ну, эээ, мне впадлу",
	-- 			function()
	-- 				surface.PlaySound("ambient/alarms/train_horn2.wav")
	-- 				notification.AddLegacy("Умри плез :3",1,30)
	-- 				slf.button:SetVisible(false)
	-- 			end
	-- 		)
	-- 	end,
	-- 	ICO = "materials/vgui/ym-studios/icons/mail.png",
	-- },
	{
		NAME = "Правила",
		URL = "http://trigon.im/index.php?help/prisma-rules/",
		ICO = "materials/vgui/icons/fa32/exclamation-circle.png",
	},
	-- {
	-- 	NAME = "Предложить идею",
	-- 	URL = "https://trigon.im/index.php?forums/predlozhenija/",
	-- 	CLFUNC = function(slf)
	-- 		ui.OpenURL(slf.URL)
	-- 	end,
	-- 	ICO = "materials/vgui/ym-studios/icons/speech.png",
	-- },
	{
		NAME = "Донат",
		URL = "https://trigon.im/index.php?posts/18/",
		CLFUNC = function(slf)
			Derma_Query("Откроется меню автоматического доната. Вы уверены, что заинтересованы?",
				"Автодонат",
				"Да",
				function()
					IGS.UI()
					notification.AddLegacy("Спасибо за проявление интереса :3",3,60)
				end,
				"Закрыть",
				function()
					notification.AddLegacy("А жаль :(",4,30)
				end
			)
		end,
		ICO = "materials/vgui/icons/fa32/dollar.png",
	},
	-- {
	-- 	NAME = "Узнать стимайди",
	-- 	URL = "https://trigon.im/index.php?posts/36",
	-- 	ICO = "materials/vgui/ym-studios/icons/question.png",
	-- },
	-- {
	-- 	NAME = "Google",
	-- 	URL = "https://google.com",
	-- 	ICO = "materials/vgui/ym-studios/icons/magnifier.png",
	-- },
	{
		NAME = "Создатель",
		URL = "https://vk.com/amd_nick",
		CLFUNC = function(slf)
			Derma_Query("Строго запрещено писать сообщения вида \"Ты тут?\", писать жалобы или несколько мелких сообщений подряд. За это вы попадете в ЧС",
				"Связаться с владельцем",
				"Я согласен",
				function() ui.OpenURL(slf.URL) end,
				"Хочу позаебывать",
				function()
					surface.PlaySound("ambient/alarms/train_horn2.wav")
					notification.AddLegacy("...",1,30)
					slf.button:SetVisible(false)
				end
			)
		end,
		ICO = "materials/vgui/icons/fa32/code.png",
	},
	-- {
	-- 	NAME = "Контент",
	-- 	URL = "http://steamcommunity.com/workshop/filedetails/?id=462356075",
	-- 	CLFUNC = function(slf)
	-- 		ui.OpenURL(slf.URL)
	-- 	end,
	-- 	ICO = "materials/vgui/ym-studios/icons/marketing.png",
	-- },
	{
		NAME = "Группа Steam",
		URL = "https://steamcommunity.com/groups/trigonim",
		CLFUNC = function(slf)
			ui.OpenURL(slf.URL)
		end,
		ICO = "materials/vgui/icons/fa32/steam-square.png",
	},
	-- {
	-- 	NAME = "Все сервера",
	-- 	URL = "http://server.trigon.im",
	-- 	CLFUNC = function(slf)
	-- 		ui.OpenURL(slf.URL)
	-- 	end,
	-- 	ICO = "materials/vgui/ym-studios/icons/signpost.png",
	-- },
}

