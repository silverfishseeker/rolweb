class ModelController < ApplicationController
    http_basic_authenticate_with name: "yomismo", password: "yasabes", except: [:index, :show]
end
