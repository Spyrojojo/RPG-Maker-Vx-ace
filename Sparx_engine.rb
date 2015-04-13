################################################################################
# Auteur : Spyrojojo
# Titre : Sparx Engine
# Description : Script pour l'aide a la conception d'un spyro like
################################################################################

module Sparx_config
  Font.default_name = ["Copperplate Gothic Bold"]
  Font.default_size = 20
  Font.default_color = Color.new(198 ,145 ,54, 255)
end
###############################################################################
###############################################################################
##### GESTION DU MENU SPYRO
###############################################################################
###############################################################################

#--------------------------------------------------------------------------
# Scene_MenuBase
#--------------------------------------------------------------------------
class Scene_MenuBase
  alias_method :sparx_start, :start
  def start
    sparx_start
    create_background
  end
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(0, 0, 0, 0)
    @joyaux = Sprite.new
    @gemme = Sprite.new
    @joyaux.bitmap = Cache.picture("Interface/Joyaux")
    @gemme.bitmap = Cache.picture("Interface/Gemme")
  end
end

#--------------------------------------------------------------------------
# Scene_Menu
#--------------------------------------------------------------------------
class Scene_Menu
  def start
    super
    $lw = Graphics.width / 2; $hw = Graphics.height / 2
    create_pau
    create_cmd
  end 
  def create_pau
    @pause = Window_Pause.new
  end
  def create_cmd
    @command = Window_Commands.new($lw-80, $hw-100)
    @command.set_handler(:reprendre, method(:reprendre))
    @command.set_handler(:atlas, method(:atlas))
    @command.set_handler(:aide, method(:aide))
    @command.set_handler(:quitter, method(:quitter))
    @command.set_handler(:cancel, method(:return_scene))
  end
  
    def reprendre; SceneManager.call(Scene_Map); end
    def atlas; SceneManager.call(Scene_Atlas); end
    def aide; SceneManager.call(Scene_Help); end
    def quitter; SceneManager.exit; end
end
  
#--------------------------------------------------------------------------
# Window_Commands
#--------------------------------------------------------------------------
class Window_Commands < Window_Command
    def make_command_list
    add_command("Reprendre", :reprendre)
    add_command("Atlas", :atlas)
    add_command("Aide", :aide)
    add_command("Quitter", :quitter)
  end
end

class Window_Pause < Window_Base  
  def initialize
    super($lw-80, $hw-141, 160, 45)
    self.contents.draw_text(40, -4, 320, 32, "Pause")
  end
end

#--------------------------------------------------------------------------
# Scene_Atlas
#--------------------------------------------------------------------------
class Scene_Atlas < Scene_MenuBase
  def start
    super
    create_atl
    create_lst
  end
  def create_atl; @atl = Window_Atl.new; end
  def create_lst
    @lst = Window_Lst.new(0, 0)
    @lst.set_handler(:monde1, method(:monde1))
    @lst.set_handler(:monde2, method(:monde2))
    @lst.set_handler(:monde3, method(:monde3))
    @lst.set_handler(:monde4, method(:monde4))
  end
  def monde1; end
  def monde2; end
  def monde3; end
  def monde4; end
end
  
#--------------------------------------------------------------------------
# Window_Atl
#--------------------------------------------------------------------------
class Window_Atl < Window_Base
  def initialize
    super(0, 50, $lw * 2, 45)
    self.contents.draw_text(231, -4, 320, 32, "Atlas")
  end
end

#--------------------------------------------------------------------------
# Window_Atl
#--------------------------------------------------------------------------
class Window_Lst < Window_HorzCommand
  def window_width
    @window_width = 542
  end
  def make_command_list
    add_command("Monde 1", :monde1)
    add_command("Monde 2", :monde2)
    add_command("Monde 3", :monde3)
    add_command("Monde 4", :monde4)
  end
end

###############################################################################
###############################################################################
# GESTION DES APARENCES
###############################################################################
###############################################################################
#---------------------------------------------------------------------------
# Scene_Map
#---------------------------------------------------------------------------
class Scene_Map
  alias_method :sparxmap_update, :update 
  def actor_change(id, name, index)
     $game_actors[id].character_name = name
     $game_actors[id].character_index = index
     $game_player.refresh
  end
  def update
    sparxmap_update
    @region = $game_map.region_id($game_player.ax / 32, $game_player.ay / 32)
    @mov = Input.press?(:RIGHT) || Input.press?(:LEFT) #Detection de deplacement
#Chancement d'apparence
    if @region == 1
      actor_change(1, @mov ? "Spyro/$xpSPYROMARCHE" : "Spyro/$xpSPYROARRET", 0)
    else
      actor_change(1, "!$Joyaux bleu", 0) 
    end
  end
end
