class AdminController < ApplicationController
    http_basic_authenticate_with name: "yomismo", password: "yasabess"
    def control
    end
    def items_no_categ
    end
end

