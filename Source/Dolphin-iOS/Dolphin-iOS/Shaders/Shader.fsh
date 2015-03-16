//
//  Shader.fsh
//  Dolphin-iOS
//
//  Created by mac on 2015-03-16.
//  Copyright (c) 2015 OatmealDome. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
