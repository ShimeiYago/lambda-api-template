from tensorflow.keras.applications.vgg16 import VGG16, preprocess_input
from tensorflow.keras import preprocessing
import numpy as np
import base64
import PIL
import io
import json

def handler(event, context):
    # 学習済みモデルをロード
    model = VGG16(weights='models/vgg16_weights_tf_dim_ordering_tf_kernels.h5')

    # リクエストBodyから入力画像(base64形式)を取得
    input_image_base64 = event["inputImageBase64"]
    
    # 入力画像をPIL形式に変換
    img = base64_to_pil(input_image_base64)

    # サイズをVGG16のデフォルトである224x224にリサイズ
    img = img.resize((224, 224))

    # 読み込んだPIL形式の画像をarrayに変換
    x = preprocessing.image.img_to_array(img)
    x = np.expand_dims(x, axis=0)
    
    # 予測
    preds = model(preprocess_input(x))
    
    # 最も高い確率のクラス名を取得
    max_index = np.argmax(preds)
    with open("models/imagenet_class_index.json") as f:
        class_index = json.load(f)
        class_name = class_index[str(max_index)][1]
    
    # レスポンス
    res = {
        "class": class_name
    }
    return res


# base64画像文字列をデコードしてPIL画像に変換
def base64_to_pil(img_base64):
    img_data = base64.b64decode(img_base64)
    img = PIL.Image.open(io.BytesIO(img_data))
    return img