Physico.GL = {
    canvas: Physico.canvas,
    gl: null,
    shaderProgram: null,
    pBuffer: null,
    cBuffer: null,
    pbBuffer: null,
    cbBuffer: null,
    pMatrix: mat4.create(),
    mvMatrix: mat4.create(),
    getShader: function(gl, id) {
        var shaderScript = document.getElementById(id);
        if (!shaderScript) {
            return null;
        }

        var str = "";
        var k = shaderScript.firstChild;
        while (k) {
            if (k.nodeType == 3) {
                str += k.textContent;
            }
            k = k.nextSibling;
        }

        var shader;
        if (shaderScript.type == "x-shader/x-fragment") {
            shader = gl.createShader(gl.FRAGMENT_SHADER);
        } else if (shaderScript.type == "x-shader/x-vertex") {
            shader = gl.createShader(gl.VERTEX_SHADER);
        } else {
            return null;
        }

        gl.shaderSource(shader, str);
        gl.compileShader(shader);

        if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
            alert(this.gl.getShaderInfoLog(shader));
            return null;
        }

        return shader;
    },
    setMatrixUniforms: function() {
        this.gl.uniformMatrix4fv(this.shaderProgram.pMatrixUniform, false, this.pMatrix);
        this.gl.uniformMatrix4fv(this.shaderProgram.mvMatrixUniform, false, this.mvMatrix);
    },
    initGL: function(){
        try {
            this.canvas = Physico.canvas
            this.gl = this.canvas.getContext("experimental-webgl");
            this.updateViewport();
        } catch (e) {
        }
        if (!this.gl) {
            alert("Could not initialise WebGL, sorry :-(");
        }
    } ,
    updateViewport: function()    {
        this.canvas.width = window.innerWidth;
        this.canvas.height = window.innerHeight;
        this.gl.viewportWidth = this.canvas.width;
        this.gl.viewportHeight = this.canvas.height;
    },
    initShaders: function(){
        var fragmentShader = this.getShader(this.gl, "fragment");
        var vertexShader = this.getShader(this.gl, "vertex");
        this.shaderProgram = this.gl.createProgram();
        this.gl.attachShader(this.shaderProgram, vertexShader);
        this.gl.attachShader(this.shaderProgram, fragmentShader);
        this.gl.linkProgram(this.shaderProgram);

        if (!this.gl.getProgramParameter(this.shaderProgram, this.gl.LINK_STATUS)) {
            alert("Could not initialise shaders");
        }

        this.gl.useProgram(this.shaderProgram);

        this.shaderProgram.vertexPositionAttribute = this.gl.getAttribLocation(this.shaderProgram, "vertexPosition");
        this.gl.enableVertexAttribArray(this.shaderProgram.vertexPositionAttribute);
        this.shaderProgram.vertexColorAttribute = this.gl.getAttribLocation(this.shaderProgram, "vertexColor");
        this.gl.enableVertexAttribArray(this.shaderProgram.vertexColorAttribute);

        this.shaderProgram.pMatrixUniform = this.gl.getUniformLocation(this.shaderProgram, "uPMatrix");
        this.shaderProgram.mvMatrixUniform = this.gl.getUniformLocation(this.shaderProgram, "uMVMatrix");
    },
    initBuffer: function(){
        this.pBuffer = this.gl.createBuffer();
        this.gl.bindBuffer(this.gl.ARRAY_BUFFER, this.pBuffer);
        var angle;
        var vertices = [0, 0, 0]
        for(i = 0; i <= 100; i++)   {
            angle = Math.PI * 2 * (i / 100);
            vertices.push(Math.cos(angle), Math.sin(angle), 0);
        }
        this.pBuffer.numItems = 102
        vertices = new Float32Array(vertices);
        this.gl.bufferData(this.gl.ARRAY_BUFFER, vertices, this.gl.STATIC_DRAW);
        this.pBuffer.itemSize = 3



        var vertices = [];
        for (j = 0; j < Physico.ObjectList.colors.length; j++)  {
            vertices[j] = [];
            vertices[j].push(Physico.ObjectList.colors[j][0][0], Physico.ObjectList.colors[j][0][1], Physico.ObjectList.colors[j][0][2], Physico.ObjectList.colors[j][0][3])
            for(i = 0; i <= 100; i++)   {
                vertices[j].push(Physico.ObjectList.colors[j][1][0], Physico.ObjectList.colors[j][1][1], Physico.ObjectList.colors[j][1][2], Physico.ObjectList.colors[j][1][3])
            }
        }
        this.cBuffer = [];
        for(j = 0; j < Physico.ObjectList.colors.length; j++)   {
            this.cBuffer[j] = this.gl.createBuffer();
            v = new Float32Array(vertices[j]);

            this.gl.bindBuffer(this.gl.ARRAY_BUFFER, this.cBuffer[j]);
            this.gl.bufferData(this.gl.ARRAY_BUFFER, v, this.gl.STATIC_DRAW);
            this.cBuffer[j].numItems = 102;
            this.cBuffer[j].itemSize = 4;
        }

        this.pbBuffer = this.gl.createBuffer();
        this.gl.bindBuffer(this.gl.ARRAY_BUFFER, this.pbBuffer);
        var angle, sin, cos;
        vertices = [];
        for(i = 0; i <= 100; i++)   {
            angle = Math.PI * 2 * (i / 100);
            sin = Math.sin(angle);
            cos = Math.cos(angle);
            vertices.push(cos, sin, 0);
            vertices.push(cos + 0.025, sin + 0.025, 0);
        }
        this.pbBuffer.numItems = 202;
        vertices = new Float32Array(vertices);
        this.gl.bufferData(this.gl.ARRAY_BUFFER, vertices, this.gl.STATIC_DRAW);
        this.pbBuffer.itemSize = 3
        this.cbBuffer = this.gl.createBuffer();
        this.gl.bindBuffer(this.gl.ARRAY_BUFFER, this.cbBuffer);
        var angle;
        vertices = []
        for(i = 0; i <= 100; i++)   {
            vertices.push(0.0, 0.0, 0.0, 1.0);
            vertices.push(0.0, 0.0, 0.0, 0.7);
        }
        this.cbBuffer.numItems = 202;
        vertices = new Float32Array(vertices);
        this.gl.bufferData(this.gl.ARRAY_BUFFER, vertices, this.gl.STATIC_DRAW);
        this.cbBuffer.itemSize = 4;
    },
    drawScene: function() {
        this.gl.viewport(0, 0, window.innerWidth, window.innerHeight);
        this.gl.clear(this.gl.COLOR_BUFFER_BIT | this.gl.DEPTH_BUFFER_BIT);
        this.gl.enable(this.gl.DEPTH_TEST);
        this.gl.depthFunc(this.gl.LESS);
        mat4.perspective(45, window.innerWidth / window.innerHeight, 0.1, 1000.0, this.pMatrix);
        mat4.identity(this.mvMatrix);
        mat4.translate(this.mvMatrix, Physico.scene)
        for (obj in Physico.ObjectList.objects) {
            if(obj) pobj = Physico.ObjectList.objects[obj - 1]
            obj = Physico.ObjectList.objects[obj];
            mat4.translate(this.mvMatrix, [obj.x, obj.y, -obj.z]);
            this.gl.bindBuffer(this.gl.ARRAY_BUFFER, this.pBuffer);
            this.gl.vertexAttribPointer(this.shaderProgram.vertexPositionAttribute, this.pBuffer.itemSize, this.gl.FLOAT, false, 0, 0);
            this.gl.bindBuffer(this.gl.ARRAY_BUFFER, this.cBuffer[obj.color]);
            this.gl.vertexAttribPointer(this.shaderProgram.vertexColorAttribute, this.cBuffer[obj.color].itemSize, this.gl.FLOAT, false, 0, 0);
            this.setMatrixUniforms();
            this.gl.drawArrays(this.gl.TRIANGLE_FAN, 0, this.pBuffer.numItems);

            this.gl.bindBuffer(this.gl.ARRAY_BUFFER, this.pbBuffer);
            this.gl.vertexAttribPointer(this.shaderProgram.vertexPositionAttribute, this.pbBuffer.itemSize, this.gl.FLOAT, false, 0, 0);
            this.gl.bindBuffer(this.gl.ARRAY_BUFFER, this.cbBuffer);
            this.gl.vertexAttribPointer(this.shaderProgram.vertexColorAttribute, this.cbBuffer.itemSize, this.gl.FLOAT, false, 0, 0);
            this.setMatrixUniforms();
            this.gl.drawArrays(this.gl.TRIANGLE_STRIP, 0, this.pbBuffer.numItems);


            mat4.translate(this.mvMatrix, [-obj.x, -obj.y, obj.z]);
        }
    },
    init: function()    {
        this.initGL();
        this.initShaders();
        this.initBuffer();
    }
}