-- ####################################################################################
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     CASUAL BANANAS CONFIDENTIAL                                                ##
-- ##                                                                                ##
-- ##     __________________________                                                 ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     Copyright 2014 (c) Casual Bananas                                          ##
-- ##     All Rights Reserved.                                                       ##
-- ##                                                                                ##
-- ##     NOTICE:  All information contained herein is, and remains                  ##
-- ##     the property of Casual Bananas. The intellectual and technical             ##
-- ##     concepts contained herein are proprietary to Casual Bananas and may be     ##
-- ##     covered by U.S. and Foreign Patents, patents in process, and are           ##
-- ##     protected by trade secret or copyright law.                                ##
-- ##     Dissemination of this information or reproduction of this material         ##
-- ##     is strictly forbidden unless prior written permission is obtained          ##
-- ##     from Casual Bananas                                                        ##
-- ##                                                                                ##
-- ##     _________________________                                                  ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     Casual Bananas is registered with the "Kamer van Koophandel" (Dutch        ##
-- ##     chamber of commerce) in The Netherlands.                                   ##
-- ##                                                                                ##
-- ##     Company (KVK) number     : 59449837                                        ##
-- ##     Email                    : info@casualbananas.com                          ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ####################################################################################


local color_text = Color(223,223,223,230);
local matGradient = Material("materials/jailbreak_excl/gradient.png"); 
local frame;
function JB.MENU_SCRIPTDAYS()
	if LocalPlayer().GetWarden and LocalPlayer():GetWarden() and tobool(JB.Config.wardenControl) then
		if IsValid(frame) then frame:Remove() end
		
		frame = vgui.Create("JB.Frame");
		frame:SetTitle("Scriptdays");
		
		if (JB.State == STATE_LASTREQUEST) or (IsValid(JB.TRANSMITTER) and JB.TRANSMITTER:GetJBScriptday() ~= "") then
			
			local lbl = Label("A scriptday cannot be activated at this time.",frame);
			lbl:SetFont("JBSmall");
			lbl:SetColor(color_text);
			lbl:SizeToContents();
			lbl:SetPos(15,30+15);
			frame:SetSize(lbl:GetWide() + 30,30+15+lbl:GetTall()+15);
		else
			frame:SetWide(620);
			local left = frame:Add("JB.Panel");
			left:SetSize(math.Round(frame:GetWide() * .35) - 15,412);
			left:SetPos(10,40);

			local right = frame:Add("JB.Panel");
			right:SetSize(math.Round(frame:GetWide() * .65) - 15,412);
			right:SetPos(left:GetWide() + left.x + 10,40);

			frame:SetTall(math.Round(right:GetTall() + 50))


			-- populate right panel
			local lr_selected;
			local lbl_ScriptdayName = Label("",right);
			lbl_ScriptdayName:SetPos(20,20);
			lbl_ScriptdayName:SetFont("JBLarge");
			lbl_ScriptdayName:SizeToContents();
			lbl_ScriptdayName:SetColor(color_text);

			local lbl_ScriptdayDetails = Label("",right);
			lbl_ScriptdayDetails:SetPos(20,lbl_ScriptdayName.y + lbl_ScriptdayName:GetTall() + 16);
			lbl_ScriptdayDetails:SetColor(color_text);
			lbl_ScriptdayDetails:SetFont("JBSmall");
			lbl_ScriptdayDetails:SetSize(right:GetWide() - 40,right:GetTall() - lbl_ScriptdayDetails.y - 30-30-32);
			lbl_ScriptdayDetails:SetWrap(true);
			lbl_ScriptdayDetails:SizeToContents();
			local btn_accept = right:Add("JB.Button");
			btn_accept:SetSize(right:GetWide() - 60,32);
			btn_accept:SetPos(30,right:GetTall() - 30 - btn_accept:GetTall());
			btn_accept:SetText("Start Scriptday");
			btn_accept.OnMouseReleased = (function()
				--local Menu = DermaMenu()
				--local btn = Menu:AddOption("Are you sure you want to start a Scriptday?",function() 
					print(lr_selected)
					RunConsoleCommand("jb_warden_scriptday",lr_selected);
					if IsValid(frame) then frame:Remove() end
				--end)
				--Menu:Open();
			end);
			btn_accept:SetVisible(false);

			--populate left panel

			left:DockMargin(0,0,0,0);
			local function selectScriptday(name,description,func,icon)
				btn_accept:SetVisible(true);
				lr_selected = func;
				lbl_ScriptdayName:SetText(name);
				lbl_ScriptdayName:SizeToContents();
			
				lbl_ScriptdayDetails:SetPos(20,lbl_ScriptdayName.y + lbl_ScriptdayName:GetTall() + 16);
				lbl_ScriptdayDetails:SetSize(right:GetWide() - 40,right:GetTall() - lbl_ScriptdayDetails.y - 30-30-32);
				lbl_ScriptdayDetails:SetText(description);
				lbl_ScriptdayDetails:SetWrap(true);
			
			end
			function createScriptDayEntry(name,description,func,icon)
				local pnl = vgui.Create("JB.Panel",left);
				pnl:SetTall(26);
				pnl:Dock(TOP);
				pnl:DockMargin(6,6,6,0);
				pnl.a = 80;
				pnl.Paint = function(self,w,h)
					draw.RoundedBox(4,0,0,w,h,JB.Color["#777"]);
					
					self.a = Lerp(0.1,self.a,self.Hover and 140 or 80);
			
					surface.SetMaterial(matGradient);
					surface.SetDrawColor(Color(0,0,0,self.a));
					surface.DrawTexturedRectRotated(w/2,h/2,w,h,180);
			
					surface.SetDrawColor(JB.Color.white);
					surface.SetMaterial(icon);
					surface.DrawTexturedRect(5,5,16,16);
			
					draw.SimpleText(name,"JBNormal",28,h/2,JB.Color.white,0,1);
				end
			
				local dummy = vgui.Create("Panel",pnl);
				dummy:SetSize(pnl:GetWide(),pnl:GetTall());
				dummy:SetPos(0,0);
				dummy.OnMouseReleased = function()
					selectScriptday(name,description,func,icon);
				end
				dummy.OnCursorEntered = function()
					pnl.Hover = true;
				end
				dummy.OnCursorExited=function()
					pnl.Hover = false;
				end
			
				pnl.PerformLayout = function(self)
					dummy:SetSize(self:GetWide(),self:GetTall());
				end
			end
			
			--SCRIPTDAYS GO HERE AND IN SV_WARDEN.LUA--

			createScriptDayEntry("Gang War Day","Prisoners and guards are now the Bloods and Crips. Each team will have grappling hooks, Mac 10s, USPs, and knives to fight each other with.","GangWarDay",Material("icon16/gun.png"))
			

		
		
		frame:Center();
		frame:MakePopup();
	end
end
end
