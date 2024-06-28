class Post < ApplicationRecord
    include Rails.application.routes.url_helpers
    has_one_attached :qrcode, dependent: :destroy
    before_commit :generate_qrcode, on: :create

    private

    def generate_qrcode
        #Get the host
        host = Rails.application.config.action_controller.default_url_options[:host]
        # Create the QRCode object
        # qrcode = RQRCode::QRCode.new("https://#{host}/posts/#{id}")
        qrCode = RQRCode::QRCode.new(post_url(self, host:))
        # Generate the QRCode as a PNG image
        png = qrCode.as_png(
            bit_depth: 1,
            border_modules: 4,
            color_mode: ChunkyPNG::COLOR_GRAYSCALE,
            color: "black",
            file: nil,
            fill: "white",
            module_px_size: 6,
            resize_exactly_to: false,
            resize_gte_to: false,
            size: 120
        )
        # Save the QRCode as an attachment
        self.qrcode.attach(
            io:StringIO.new(png.to_s),
            filename: "qrcode.png",
            content_type: "image/png"
            )
    end
end
