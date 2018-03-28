function tts( text )

if nargin<1
    text = 'Please call this function with text';
end
try
    NET.addAssembly('System.Speech');
    Speaker = System.Speech.Synthesis.SpeechSynthesizer;
    if ~isa(text,'cell')
        text = {text};
    end
    for k=1:length(text)
        Speaker.Speak (text{k});
    end
catch
    warning(['If this is not a Windows system or ' ...
        'the .Net class exists you will not be able to use this function.' ...
        'Please let me know what went wrong: wgarn@yahoo.com']);
end

