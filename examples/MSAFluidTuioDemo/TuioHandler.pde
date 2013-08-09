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

import TUIO.*;
import java.util.Vector;

TuioProcessing tuioClient;

final static float tuioCursorSpeedMult = 0.02f; // the iphone screen is so small, easy to rack up huge velocities! need to scale down 
final static float tuioStationaryForce = 0.001; // force exerted when cursor is stationary
final static float tuioDoubleTapDistanceThreshold2 = 0.01; // distance squared (in tuio units) of last two taps in order to count as doubletap
final static float tuioDoubleTapTimeThreshold = 0.2; // seconds between last two taps in order to count as doubletap

TuioPoint tuioLastTap;        // stores last tap information (to detect double tap)
boolean tuioDoubleTap = false;

void initTUIO() {
    tuioClient  = new TuioProcessing(this);
}


void updateTUIO() {
    Vector tuioCursorList = tuioClient.getTuioCursors();
    for (int i=0;i<tuioCursorList.size();i++) {
        TuioCursor tcur = (TuioCursor)tuioCursorList.elementAt(i);
        float vx = tcur.getXSpeed() * tuioCursorSpeedMult;
        float vy = tcur.getYSpeed() * tuioCursorSpeedMult;
        if(vx == 0 && vy == 0) {
            vx = random(-tuioStationaryForce, tuioStationaryForce);
            vy = random(-tuioStationaryForce, tuioStationaryForce);
        }
        addForce(tcur.getX(), tcur.getY(), vx, vy);
    }


    if(tuioDoubleTap) {
        drawFluid ^= true;
        tuioDoubleTap = false;
    }
}

void addTuioObject(TuioObject tobj) {
}

void updateTuioObject(TuioObject tobj) {
}

void removeTuioObject(TuioObject tobj) {
}



void addTuioCursor(TuioCursor tcur) {
    // check for double tap
    if(tuioLastTap != null) {  // only do this if we have a previous tap
    float timeMult = 0.000001;   // getTotalMilliseconds seems to be returning microseconds instead of milliseconds in current TUIO client library :/
        float nowTime = tcur.getTuioTime().getTotalMilliseconds() * timeMult;
        float lastTime = tuioLastTap.getTuioTime().getTotalMilliseconds() * timeMult;
//        println(nowTime + " - " + lastTime);
        if(nowTime - lastTime < tuioDoubleTapTimeThreshold) {    // check time different between current and previous tap
            float dx = tcur.getX() - tuioLastTap.getX(); // horizontal distance
            float dy = tcur.getY() - tuioLastTap.getY(); // vertical distance
            float d2 = dx * dx + dy * dy; // square of distance between taps
//            println(d2);
            if(d2 < tuioDoubleTapDistanceThreshold2) tuioDoubleTap = true; 
        }
    }

    tuioLastTap = new TuioPoint(tcur); // store info for next tap
}

void updateTuioCursor(TuioCursor tcur) {
}

void removeTuioCursor(TuioCursor tcur) {
}

void refresh(TuioTime bundleTime) {
}










