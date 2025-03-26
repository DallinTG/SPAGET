 #version 330
 in vec3 fragPosition;
 in vec2 fragTexCoord;
 in vec4 fragColor;
 in vec3 fragNormal;

 
 uniform sampler2D texture0;
 uniform vec4 colDiffuse;
 
 out vec4 finalColor;


//  vec2 uv_klems(vec2 uv,vec2 texture_size) {

// 	vec2 pixels = uv * texture_size;
    
//     // tweak fractionnal value of the texture coordinate
//     vec2 fl = floor(pixels);
//     vec2 fr = fract(pixels);
//     vec2 aa = fwidth(pixels) * 1;
//     fr = smoothstep( vec2(0.5)-aa, vec2(0.5)+aa, fr);
    
//     // uv = (fl+fr-0.5) / res;
//     return uv = (fl+fr-0.5) / texture_size;
    
// }

 void main()
 {
    // vec4 texelColor = texture(texture0, uv_klems(fragTexCoord,vec2(textureSize(texture0,0))));
	vec4 texelColor = texture2D(texture0, fragTexCoord);


	if( texelColor.a <= 0.0 )
	{
		discard;
	}



    finalColor = texelColor*colDiffuse*fragColor;


 }    