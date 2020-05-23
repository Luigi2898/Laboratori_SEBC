function [] = matrix2tableLatex(fieldsHorz,fieldsVert,inputMatrix,colorFlag)
% La funzione accetta un vettore di stringhe con i campi delle colonne della tabella 
% denominato fieldsVert ed un altro vettore dello stesso tipo per i campi
% orizzontali.
% Per non utilizzarne uno basta passare il vettore vuoto.
% Il flag colorFlag indica alla funzione se l'output sarà in gradazioni di
% grigio o bianco.

if ((numel(fieldsHorz) ~= numel(inputMatrix(:,1))) && (~isempty(fieldsHorz)))
    fprintf("ERRORE: Il numero di titoli delle righe non corrisponde al numero di righe della tabella dati.\n");
else
    if numel(fieldsVert) ~= numel(inputMatrix(1,:))
        fprintf("ERRORE: Il numero di titoli delle colonne non corrisponde al numero di colonne della tabella dati.\n");
    else
        
        
        
        colorToggle = 1;
        rowColor = 9;
        colNum = 0;
        
        fprintf("\n\\begin{table}[H]\n\t\\centering\n\t\\begin{tabular}{");
        
        if isempty(fieldsHorz)
            colNum = numel(fieldsVert);
        else
            colNum = numel(fieldsVert)+1;
        end
        for i=1:colNum
            if i==colNum
                fprintf("c}\n");
            else
                fprintf("c|");
            end
        end
        
        if colorFlag == 1
            for i=1:numel(inputMatrix(:,1))+1
                fprintf("\t\t\\rowcolor[gray]{.%d} ",rowColor);
                colorToggle = colorToggle*(-1);
                rowColor = rowColor + colorToggle;
                if isempty(fieldsHorz)
                    if i==1
                        for j=1:numel(inputMatrix(1,:))
                            if j==numel(inputMatrix(1,:))
                                fprintf("%s\\\\\n",fieldsVert(j));
                            else
                                fprintf("%s & ",fieldsVert(j));
                            end
                        end
                    else
                        for j=1:numel(inputMatrix(1,:))
                            if j==numel(inputMatrix(1,:))
                                fprintf("%.3f\\\\\n",inputMatrix(i-1,j));
                            else
                                fprintf("%.3f & ",inputMatrix(i-1,j));
                            end
                        end
                    end
                else
                    if i==1
                        for j=1:numel(inputMatrix(1,:))+1
                            if j==1
                                fprintf("\t  & ");
                            else
                                if j==numel(inputMatrix(1,:))+1
                                    fprintf("%s\\\\\n",fieldsVert(j-1));
                                else
                                    fprintf("%s & ",fieldsVert(j-1));
                                end
                            end
                        end
                    else
                        for j=1:numel(inputMatrix(1,:))+1
                            if j==1
                                fprintf("%s & ",fieldsHorz(i-1));
                            else
                                if j==numel(inputMatrix(1,:))+1
                                    fprintf("%.3f\\\\\n",inputMatrix(i-1,j-1));
                                else
                                    fprintf("%.3f & ",inputMatrix(i-1,j-1));
                                end
                            end
                        end
                    end
                end
            end
        else
            for i=1:numel(inputMatrix(:,1))+1
                fprintf("\t\t ");
                if isempty(fieldsHorz)
                    if i==1
                        for j=1:numel(inputMatrix(1,:))
                            if j==numel(inputMatrix)
                                fprintf("%s\\\\\n",fieldsVert(j));
                            else
                                fprintf("%s & ",fieldsVert(j));
                            end
                        end
                    else
                        for j=1:numel(inputMatrix(1,:))
                            if j==numel(inputMatrix)
                                fprintf("%.3f\\\\\n",inputMatrix(i-1,j));
                            else
                                fprintf("%.3f & ",inputMatrix(i-1,j));
                            end
                        end
                    end
                else
                    if i==1
                        for j=1:numel(inputMatrix(1,:))+1
                            if j==1
                                fprintf("\t  & ");
                            else
                                if j==numel(inputMatrix(1,:))+1
                                    fprintf("%s\\\\\n",fieldsVert(j-1));
                                else
                                    fprintf("%s & ",fieldsVert(j-1));
                                end
                            end
                        end
                    else
                        for j=1:numel(inputMatrix(1,:))+1
                            if j==1
                                fprintf("%s & ",fieldsHorz(i-1));
                            else
                                if j==numel(inputMatrix(1,:))+1
                                    fprintf("%.3f\\\\\n",inputMatrix(i-1,j-1));
                                else
                                    fprintf("%.3f & ",inputMatrix(i-1,j-1));
                                end
                            end
                        end
                    end
                end
            end
        end
        
        fprintf("\t\\end{tabular}\n");
        fprintf("\t\\caption{\\textit{   }}\n");
        fprintf("\t\\label{   }\n");
        fprintf("\\end{table}\n\n");
    end
end

end

