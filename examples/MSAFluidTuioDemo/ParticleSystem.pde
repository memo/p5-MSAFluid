/***********************************************************************
 
 Copyright (c) 2008, 2009, Memo Akten, www.memo.tv
 *** The Mega Super Awesome Visuals Company ***
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of MSA Visuals nor the names of its contributors 
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE. 
 *
 * ***********************************************************************/ 

import java.nio.FloatBuffer;
import com.sun.opengl.util.*;

boolean renderUsingVA = true;

void fadeToColor(GL gl, float r, float g, float b, float speed) {
    gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE_MINUS_SRC_ALPHA);
    gl.glColor4f(r, g, b, speed);
    gl.glBegin(GL.GL_QUADS);
    gl.glVertex2f(0, 0);
    gl.glVertex2f(width, 0);
    gl.glVertex2f(width, height);
    gl.glVertex2f(0, height);
    gl.glEnd();
}


class ParticleSystem {
    FloatBuffer posArray;
    FloatBuffer colArray;

    final static int maxParticles = 5000;
    int curIndex;

    Particle[] particles;

    ParticleSystem() {
        particles = new Particle[maxParticles];
        for(int i=0; i<maxParticles; i++) particles[i] = new Particle();
        curIndex = 0;

        posArray = BufferUtil.newFloatBuffer(maxParticles * 2 * 2);// 2 coordinates per point, 2 points per particle (current and previous)
        colArray = BufferUtil.newFloatBuffer(maxParticles * 3 * 2);
    }


    void updateAndDraw(){
        PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;         // processings opengl graphics object
        GL gl = pgl.beginGL();                // JOGL's GL object

        gl.glEnable( GL.GL_BLEND );             // enable blending
        if(!drawFluid) fadeToColor(gl, 0, 0, 0, 0.05);

        gl.glBlendFunc(GL.GL_ONE, GL.GL_ONE);  // additive blending (ignore alpha)
        gl.glEnable(GL.GL_LINE_SMOOTH);        // make points round
        gl.glLineWidth(1);


        if(renderUsingVA) {
            for(int i=0; i<maxParticles; i++) {
                if(particles[i].alpha > 0) {
                    particles[i].update();
                    particles[i].updateVertexArrays(i, posArray, colArray);
                }
            }    
            gl.glEnableClientState(GL.GL_VERTEX_ARRAY);
            gl.glVertexPointer(2, GL.GL_FLOAT, 0, posArray);

            gl.glEnableClientState(GL.GL_COLOR_ARRAY);
            gl.glColorPointer(3, GL.GL_FLOAT, 0, colArray);

            gl.glDrawArrays(GL.GL_LINES, 0, maxParticles * 2);
        } 
        else {
            gl.glBegin(GL.GL_LINES);               // start drawing points
            for(int i=0; i<maxParticles; i++) {
                if(particles[i].alpha > 0) {
                    particles[i].update();
                    particles[i].drawOldSchool(gl);    // use oldschool renderng
                }
            }
            gl.glEnd();
        }

        gl.glDisable(GL.GL_BLEND);
        pgl.endGL();
    }


    void addParticles(float x, float y, int count ){
        for(int i=0; i<count; i++) addParticle(x + random(-15, 15), y + random(-15, 15));
    }


    void addParticle(float x, float y) {
        particles[curIndex].init(x, y);
        curIndex++;
        if(curIndex >= maxParticles) curIndex = 0;
    }

}








