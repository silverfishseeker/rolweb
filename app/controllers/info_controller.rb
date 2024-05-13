class InfoController < ApplicationController
    def reglas
    end

    def estadosAlterados
        @xs = Estadoalterado.all
    end
    
    def lore
    end

    def avisolegal
    end

    def arbol
    end
end
