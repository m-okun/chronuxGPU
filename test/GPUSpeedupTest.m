function GPUSpeedupTest

params.Fs = 1000;
% alpha = 0.36;
x = randn(3600*2*params.Fs, 1); % NoiseRainbow(3600*2*params.Fs, alpha)';
y = randn(3600*2*params.Fs, 1); % NoiseRainbow(3600*2*params.Fs, alpha)';
L = 100;
params.tapers = [5/L L 5];
lim = numel(x)/4;

runTest(@mtspectrumc,    x(1:lim) - mean(x(1:lim)), params);
runTest(@mtspectrumpb,   x(1:lim) > 0,       params);
runTest(@mtspectrumsegc, x - mean(x), L, params, true);
runTest(@mtspectrumsegpb,x > 0,       L, params, true);

runTest(@coherencyc,      x(1:lim), x(1:lim)+y(1:lim),            params);
runTest(@coherencypb, x(1:lim) > 0, x(1:lim)>0 + y(1:lim)>0,    params);
runTest(@coherencycpb, x(1:lim), x(1:lim)>0 + y(1:lim)>0,    params);
runTest(@coherencysegc, x, x+y, L, params);
runTest(@coherencysegpb, x > 0, (x>0)+(y>0), L, params);
runTest(@coherencysegcpb, x, (x>0)+(y>0), L, params);

runTest(@mtspecgramc, x, [L L/2], params);
runTest(@mtspecgrampb, x > 0, [L L/2], params);

  % Inputs: chronuxFunctionH - handle to some chronux function
  %         varargin - inputs to call the function with
  function runTest(chronuxFunctionH, varargin)    
    global CHRONUXGPU
    for CHRONUXGPU = 0:1
      tic
      P = chronuxFunctionH(varargin{:});
      t = toc;
      if ~CHRONUXGPU
        Pnogpu = P;
        fprintf('%s without GPU: %1.1f s, ', func2str(chronuxFunctionH), t)
      else
        fprintf('with GPU: %1.1f s\n', t)
      end
    end    
    assert(max(abs(P(:)-Pnogpu(:))) < 1e-9)
  end % runTest subfunction

end % main function