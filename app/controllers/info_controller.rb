class InfoController < ApplicationController
    def reglas
    end

    def estadosAlterados
        @xs = Estadoalterado.all
    end
    
    def lore
    end
end
