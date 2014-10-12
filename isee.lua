module("extensions.isee", package.seeall)
extension = sgs.Package("isee")

yangzhe = sgs.General(extension, "yangzhe", "god", "4")

LuaXianYin = sgs.CreateViewAsSkill{
    name = "LuaXianYin",
    n = 1, 
    view_filter = function(self, selected, to_select)
		    -- return to_select:isBlack()
		    return true
	  end,
    view_as = function(self, cards)
        if #cards == 0 then
			     return nil
		    elseif #cards == 1 then
			  local card = cards[1]
			  local suit = card:getSuit()
			  local point = card:getNumber()
			  local id = card:getId()
			  local vs_card = sgs.Sanguosha:cloneCard("savage_assault", suit, point)
			  vs_card:addSubcard(id)
			  vs_card:setSkillName("LuaXianYin")
			  return vs_card
	    	end
	  end, 
}	  


LuaShangQu = sgs.CreateTriggerSkill{
        name = "LuaShangQu",
        frequency = sgs.Skill_NotFrequent,
        events = {sgs.EventPhaseStart},
        on_trigger = function(self, event, player, data)
            local room = player:getRoom()
            if player:isAlive() and player:hasSkill(self:objectName()) then
                if player:getPhase() == sgs.Player_Finish then
                    if player:isKongcheng() then
                        if room:askForSkillInvoke(player, self:objectName(), data) then
                        local target = room:askForPlayerChosen(player, room:getAlivePlayers(), self:objectName(), nil, true, true)
                        if not target then return false end
                        room:damage(sgs.DamageStruct(self:objectName(), player, target))
                        room:broadcastSkillInvoke(self:objectName())          
                        end
                    end
                end
            end
            return false
        end,
}


yangzhe:addSkill(LuaXianYin)
yangzhe:addSkill(LuaShangQu)

wangzhe = sgs.General(extension, "wangzhe", "god", "4")

LuaZhengTong = sgs.CreateTriggerSkill{
    name = "LuaZhengTong",
    frequency = sgs.Skill_Compulsory,
    events = {sgs.DamageInflicted},
    on_trigger = function(self, event, player, data)
        local damage = data:toDamage()
        local room = player:getRoom()
        if damage.card and (damage.card:getTypeId() == sgs.Card_TypeTrick) then
            if (event == sgs.DamageInflicted) and player:hasSkill(self:objectName()) then
                room:broadcastSkillInvoke(self:objectName()) 
                return true
            end
        end
        return false
    end,
    can_trigger = function(self, target)
        return target
    end
}

    LuaWangQuan = sgs.CreateTriggerSkill{
        name = "LuaWangQuan",
        frequency = sgs.Skill_NotFrequent,
        events = {sgs.Damage},
        on_trigger = function(self, event, player, data)
            local damage = data:toDamage()
            local room = player:getRoom()
            local target = damage.to
            if damage.card and damage.card:isKindOf("Slash") and (not player:isKongcheng())
                    and (not target:isKongcheng()) and (target:objectName() ~= player:objectName() and (not damage.chain) and (not damage.transfer)) then
                if room:askForSkillInvoke(player, self:objectName(), data) then
                    if not target:isNude() then
                        room:broadcastSkillInvoke(self:objectName()) 
                        local card_id = room:askForCardChosen(player, target, "he", self:objectName())
                        local reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_EXTRACTION, player:objectName())
                        room:moveCardTo(sgs.Sanguosha:getCard(card_id),player,sgs.Player_PlaceHand,reason)
                    end
                end
            end
            return false
        end
    }

wangzhe:addSkill(LuaZhengTong)
wangzhe:addSkill(LuaWangQuan)

hukeq = sgs.General(extension, "hukeq", "qun", "4")

LuaChiYi = sgs.CreateTriggerSkill{
    name = "LuaChiYi",
    frequency = sgs.Skill_Frequent,
    events = {sgs.EventPhaseStart},
    on_trigger = function(self, event, player, data)
        if player:getPhase() == sgs.Player_Finish then
            local room = player:getRoom()
            if room:askForSkillInvoke(player, self:objectName()) then
                local upper = math.min(4, player:getMaxHp())
                local x = upper - player:getHandcardNum()
                if x <= 0 then
                else
                    player:drawCards(x)
                end 
            end
        end
    end
}
hukeq:addSkill(LuaChiYi)

sgs.LoadTranslationTable{
    ["isee"] = "信电",
    
    ["yangzhe"] = "神杨哲",
    ["&yangzhe"] = "杨哲",
    ["#yangzhe"] = "吉他少年",
    ["LuaXianYin"] = "弦音",
    [":LuaXianYin"] = "出牌阶段限一次，你可以将一张牌当作【南蛮入侵】打出。",
    ["$LuaXianYin"] = "弦外之音，破敌万千",
    ["LuaShangQu"] = "殇曲",
    [":LuaShangQu"] = "结束阶段，若你没有手牌，你可对一名角色造成一点伤害。",
    ["$LuaShangQu"] = "心之所向，曲终人亡",
    ["designer:yangzhe"] = "胡可",
	  ["cv:yangzhe"] = "杨哲",
	  ["illustrator:yangzhe"] = "胡可",
	  
	  ["wangzhe"] = "神王哲",
    ["&wangzhe"] = "王哲",
    ["#wangzhe"] = "北大之子",
    ["LuaZhengTong"] = "正统",
    [":LuaZhengTong"] = "锁定技，你不会受到来自锦囊牌的伤害。",
    ["$LuaZhengTong"] = "旁门左道，不足为惧",
    ["LuaWangQuan"] = "王权",
    [":LuaWangQuan"] = "每当你使用【杀】对目标角色造成伤害后，可以获得其一张牌。",
    ["$LuaWangQuan"] = "普天之下，莫非王土",
    ["~wangzhe"] = "我的中国梦",
    ["designer:wangzhe"] = "胡可",
	  ["cv:wangzhe"] = "王哲",
	  ["illustrator:wangzhe"] = "胡可",
	  
	  ["hukeq"] = "胡可",
    ["&hukeq"] = "胡可",
    ["#hukeq"] = "独善其身",
    ["LuaChiYi"] = "迟疑",
    [":LuaChiYi"] = "摸牌阶段，你可以放弃摸牌，若如此做，在结束阶段将手牌补充到体力上限。",
    ["$LuaChiYi"] = "不可轻举妄动",
    ["designer:hukeq"] = "胡可",
	  ["cv:hukeq"] = "胡可",
	  ["illustrator:hukeq"] = "胡可"
}

