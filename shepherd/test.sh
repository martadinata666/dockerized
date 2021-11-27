#/!bin/bash
export APPRISE_SIDECAR_URL="http://192.168.0.3:1000/notify/"
export NOTIFICATION_URL="discord://816512109075628052/c2Dx2Kz9-rFfqAZ74Wei9Wa2zr8F3sMy0J2K9TVD3bMsxIZY2VQe3o33o0SIShIGa0oM"
export AVATAR_URL="https://res.cloudinary.com/dedyms/image/upload/w_1000,c_fill,ar_1:1,g_auto,r_max,bo_5px_solid_red,b_rgb:262c35/v1616825895/container/919853_oscoe2.png"
export USER=Shepherd
export FILTER_SERVICES=""
export TZ="Asia/Jakarta"
exec ./shepherd.discord
