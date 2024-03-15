class AdminController < ApplicationController
    http_basic_authenticate_with name: "yomismo", password: "yasabess"
    def control
    end

    def habilidads_ocultas
        redirect_to habilidads_path(mode: "hidden")
    end

    def habilidads_sueltas
        redirect_to habilidads_path(mode: "indep")
    end

    def items_no_categ
    end
end

