################################################################################
# Auteur : Spyrojojo
# Titre : Sparx Engine
# Version : 1.0.0
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
    super
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
    create_lvl
  end
  def create_atl; @atl = Window_Atl.new; end
  def create_lst
    @lst = Window_Lst.new(0, 93)
    @lst.set_handler(:monde1, method(:monde1))
    @lst.set_handler(:monde2, method(:monde2))
    @lst.set_handler(:monde3, method(:monde3))
    @lst.set_handler(:monde4, method(:monde4))
    @lst.set_handler(:cancel, method(:return_menu))
  end
  def monde1; SceneManager.call(Scene_Atlas); end
  def monde2; SceneManager.call(Scene_Atlas); end
  def monde3; SceneManager.call(Scene_Atlas); end
  def monde4; SceneManager.call(Scene_Atlas); end
  def return_menu; SceneManager.call(Scene_Menu); end
    
  def create_lvl; @lvl = Window_Lvl.new; end
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
class Window_Lst < Window_Command
  def make_command_list
    add_command("Ile verdoyante", :monde1)
    add_command("Ile désertique", :monde2)
    add_command("Ile givré", :monde3)
    add_command("Ile de jester", :monde4)
  end
end

#--------------------------------------------------------------------------
# Window_Atl
#--------------------------------------------------------------------------
class Window_Lvl < Window_Base
  def initialize
    super(158, 93, Graphics.width - 158, 323)
    self.contents.draw_text(231, -4, 320, 32, "Test")
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
# Gestion des aparances
    @mov = Input.press?(:RIGHT) || Input.press?(:LEFT)
    @dir = $game_player.direction
    if [1,2,3,4,5].include?(@region)
      actor_change(1, @mov ? "Spyro/$xpSPYROMARCHE" : "Spyro/$xpSPYROARRET", 0)
    else
      actor_change(1, "!$Joyaux bleu", 0) 
    end
# Gestion des pentes
    if [2,3].include?(@region) && @dir == 6
      $game_player.move_y(-5,1) if Input.press?(:RIGHT) && !Input.press?(:LEFT) && !Input.press?(:DOWN)&& !Input.press?(:UP)
    elsif [4,5].include?(@region) && @dir == 4
      $game_player.move_y(-5,1) if Input.press?(:LEFT) && !Input.press?(:RIGHT) && !Input.press?(:DOWN)&& !Input.press?(:UP)
    end
    
  end
end
