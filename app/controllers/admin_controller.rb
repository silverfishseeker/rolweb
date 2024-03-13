class AdminController < ApplicationController
    http_basic_authenticate_with name: "yomismo", password: "yasabess"
    def control
    end
end

