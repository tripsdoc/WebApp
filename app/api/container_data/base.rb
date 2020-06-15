module ContainerData
  class Base < Grape::API
    mount V1::Apidata
    mount V2::Apidata
  end
end