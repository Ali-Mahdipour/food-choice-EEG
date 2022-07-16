clc
close all
clearvars
warning off
sca
%% initial parameters
load('practice_with_lable')
load('question')
load('buynotbuy_L')
FP=randi([0 1],1,18);
for i=1:18
    if FP(i)==0
        first_pluse(i)=0.5;
    else
        first_pluse(i)=1;
    end
end
SP=randi([1 5],1,18);
for i=1:18
    if SP(i)==1
        second_pluse(i)=0.6;
    elseif SP(i)==2
        second_pluse(i)=0.65;
    elseif SP(i)==3
        second_pluse(i)=0.7;
    elseif SP(i)==4
        second_pluse(i)=0.75;
    elseif SP(i)==5
        second_pluse(i)=0.8;
    end
end
show_time_food=3;
show_time_question=5;
bouncing=0.5;
%% screen parameters
Screen('Preference', 'SkipSyncTests', 1); %enable this if you got screen error
PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = max(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
inc = white - grey;
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
ifi = Screen('GetFlipInterval', window);
[xCenter, yCenter] = RectCenter(windowRect);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
startCue = 0;
Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, 36);
[xCenter, yCenter] = RectCenter(windowRect);
fixCrossDimPix = 40;
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];
lineWidthPix = 4;
%% initial parameters 2 (picture properties)
[imageHeight,imageWidth,colorChannels]=size(buynotbuy);
bottomRight_Rect = [screenXpixels-100-imageWidth, screenYpixels+50-imageHeight, screenXpixels-500, screenYpixels-15];
%% mouse setting
SetMouse(round(rand * screenXpixels), round(rand * screenYpixels), window);
SetMouse(0, 0, window);

buynotbuy_x=[498 666 ; 758 937];
buynotbuy_y=[805 888];

question_x=[318 432; 436 548;543 658;664 775;778 890;891 1006;1007 1119];
question_y=[450 580];
%% start the task
% making a window to start a task
Screen('FillRect', window, white);
string_text='Please Press a Key';
DrawFormattedText(window, string_text,'center', screenYpixels * 0.5 ,[0 0 0]);
Screen('Flip', window);
KbWait;
%% %% main code
for i=1:18
    
    %first pluse
    Screen('DrawLines', window, allCoords,lineWidthPix, black, [xCenter yCenter], 2);
    
    Screen('Flip', window);
    
    WaitSecs(first_pluse(i))
    
    
    %Image_first
    imageTexture = Screen('MakeTexture', window, practice_with_lable{i});
    Screen('DrawTexture', window, imageTexture, [], [], 0);
    
    Screen('Flip', window);
    
    WaitSecs(show_time_food)
    
    %second pluse
    Screen('DrawLines', window, allCoords,lineWidthPix, black, [xCenter yCenter], 2);
    
    Screen('Flip', window);
    
    WaitSecs(second_pluse(i))
    
    
    %buy not buy image
    imageTexture1 = Screen('MakeTexture', window,practice_with_lable{i});
    imageTexture2 = Screen('MakeTexture', window,buynotbuy);
    Screen('FillRect', window, white);
    
    Screen('DrawTexture', window, imageTexture1, [], [], 0);
    Screen('DrawTexture', window, imageTexture2, [], bottomRight_Rect, 0);
    
    
    Screen('Flip', window);
    
    
    %answer to buy not buy
    T1=GetSecs;
    T=0;K(i)=0;
    buttons=0;
    while T<show_time_food && ~K(i)
        T2 = GetSecs;
        T=T2-T1;
        [x,y,buttons] = GetMouse(window);
        if any(buttons)==1
            
            
            x = min(x, screenXpixels);
            y = min(y, screenYpixels);
            WaitSecs(bouncing)
            
            if(y>buynotbuy_y(1) && y<buynotbuy_y(2))
                
                if (x>buynotbuy_x(1,1) && x<buynotbuy_x(1,2))
                    K(i)=2;  % buy
                    answer_buynotbuy{i}='buy';
                elseif (x>buynotbuy_x(2,1) && x<buynotbuy_x(2,2))
                    K(i)=1; % notbuy
                    answer_buynotbuy{i}='notbuy';
                    
                end
                
            end
            
        else
            K(i)=0; % not answer
            answer_buynotbuy{i}='not answer';
        end
    end
    
    % question
    
    imageTexture = Screen('MakeTexture', window, question);
    Screen('DrawTexture', window, imageTexture, [], [], 0);
    
    Screen('Flip', window);
    
    T1=GetSecs;
    T=0;K2(i)=0;
    buttons=0;
    while T<show_time_question && ~K2(i)
        T2 = GetSecs;
        T=T2-T1;
        [x,y,buttons] = GetMouse(window);
        if any(buttons)==1
            
            x = min(x, screenXpixels);
            y = min(y, screenYpixels);
            
            WaitSecs(bouncing)
            
            if (y>question_y(1) && y<question_y(2))
                
                if (x>question_x(1,1) && x<question_x(1,2))
                    K2(i)=1;
                    answer_question{i}='1';
                elseif (x>question_x(2,1) && x<question_x(2,2))
                    K2(i)=2;
                    answer_question{i}='2';
                elseif (x>question_x(3,1) && x<question_x(3,2))
                    K2(i)=3;
                    answer_question{i}='3';
                elseif (x>question_x(4,1) && x<question_x(4,2))
                    K2(i)=4;
                    answer_question{i}='4';
                    
                elseif (x>question_x(5,1) && x<question_x(5,2))
                    K2(i)=5;
                    answer_question{i}='5';
                    
                elseif (x>question_x(6,1) && x<question_x(6,2))
                    K2(i)=6;
                    answer_question{i}='6';
                    
                elseif (x>question_x(7,1) && x<question_x(7,2))
                    K2(i)=7;
                    answer_question{i}='7';
                end
            end
        else
            K2(i)=0; % not answer
            answer_question{i}='not answer';
        end
        
    end
end
%% End
end_text='The END';
DrawFormattedText(window, end_text,'center', screenYpixels * 0.5 ,[0 0 0]);
Screen('Flip', window);
WaitSecs(5)
sca
%%